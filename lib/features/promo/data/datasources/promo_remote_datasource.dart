import 'dart:convert';

import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/network/api_client.dart';
import 'package:smart_trader_mobile/features/promo/data/models/promo_model.dart';
import 'package:xml/xml.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getCCPromo();
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final ApiClient _apiClient;

  PromoRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PromoModel>> getCCPromo() async {
    const soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:tns="http://tempuri.org/">
  <soap:Body>
    <tns:GetCCPromo>
      <tns:lang>en</tns:lang>
    </tns:GetCCPromo>
  </soap:Body>
</soap:Envelope>''';

    final xmlResponse = await _apiClient.postSoap(
      AppConstants.promoSoapUrl,
      soapEnvelope,
      '"http://tempuri.org/CabinetMicroService/GetCCPromo"',
    );

    return _parsePromoResponse(xmlResponse);
  }

  List<PromoModel> _parsePromoResponse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);

      XmlElement? resultEl;
      for (final el in document.descendants.whereType<XmlElement>()) {
        if (el.name.local == 'GetCCPromoResult') {
          resultEl = el;
          break;
        }
      }

      final raw = resultEl?.innerText.trim() ?? '';
      if (raw.isNotEmpty) {
        final fromJson = _parsePromoJson(raw);
        if (fromJson.isNotEmpty) return fromJson;
      }


      return _parsePromoXmlItems(document);
    } catch (_) {
      return [];
    }
  }

  List<PromoModel> _parsePromoJson(String raw) {
    try {
      final sanitised = raw
          .replaceAll(RegExp(r':\s*False\b'), ': false')
          .replaceAll(RegExp(r':\s*True\b'), ': true')
          .replaceAll(RegExp(r':\s*None\b'), ': null');
      final decoded = jsonDecode(sanitised);
      if (decoded is! Map<String, dynamic>) return [];

      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final items = <PromoModel>[];
      decoded.forEach((slug, value) {
        if (value is! Map) return;
        final m = Map<String, dynamic>.from(value);


        final dieDate = (m['die_date'] is num)
            ? (m['die_date'] as num).toInt()
            : int.tryParse('${m['die_date'] ?? 0}') ?? 0;
        if (dieDate > 0 && dieDate < nowSec) return;

        final image = (m['image'] ?? '').toString();
        final text = (m['text'] ?? '').toString();
        final link = (m['link'] ?? '').toString();
        if (image.isEmpty && link.isEmpty && text.isEmpty) return;

        items.add(PromoModel(
          id: slug,
          title: text.isEmpty ? slug : text,
          imageUrl: image.replaceAll(
              'forex-images.instaforex.com', 'forex-images.ifxdb.com'),
          link: link,
          description: (m['button_text'] ?? '').toString().isEmpty
              ? null
              : m['button_text'].toString(),
          type: slug,
        ));
      });
      return items;
    } catch (_) {
      return [];
    }
  }

  List<PromoModel> _parsePromoXmlItems(XmlDocument document) {
    final promoItems = <PromoModel>[];
    for (final el in document.descendants.whereType<XmlElement>()) {
      final local = el.name.local;
      if (local == 'PromoItem' || local == 'CCPromoDetail') {
        final promo = _parsePromoItem(el);
        if (promo != null) promoItems.add(promo);
      }
    }
    return promoItems;
  }

  PromoModel? _parsePromoItem(XmlElement item) {
    try {
      String textOf(String tag) {
        for (final child in item.childElements) {
          if (child.name.local == tag) return child.innerText;
        }
        for (final el in item.descendants.whereType<XmlElement>()) {
          if (el.name.local == tag) return el.innerText;
        }
        return '';
      }

      final id = textOf('Id') + textOf('id') + textOf('ID');
      final title =
          textOf('Title') + textOf('title') + textOf('Name') + textOf('name');
      final imageUrl = textOf('ImageUrl') +
          textOf('imageUrl') +
          textOf('Image') +
          textOf('image') +
          textOf('Url') +
          textOf('url');
      final link = textOf('Link') +
          textOf('link') +
          textOf('Href') +
          textOf('href') +
          textOf('Url') +
          textOf('url');

      if (imageUrl.isEmpty && link.isEmpty) return null;

      return PromoModel(
        id: id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : id,
        title: title.isEmpty ? 'Promo' : title,
        imageUrl: imageUrl.replaceAll(
            'forex-images.instaforex.com', 'forex-images.ifxdb.com'),
        link: link,
        description: textOf('Description') + textOf('description'),
        type: textOf('Type') + textOf('type'),
      );
    } catch (_) {
      return null;
    }
  }
}
