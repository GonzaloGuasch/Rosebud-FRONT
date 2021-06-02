
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/widgets/Marketplace/Marketplace.dart';

class DialogoUploadOffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oferta subida!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Su oferta fue subida con exito'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DialogUploadOfferError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error en la subida'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('No se pudo subir su oferta, vuelva a intentarlo mas tarde'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MarketPlace()),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}



