From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v3 1/6] md: Make md resync and reshape threads freezable
Date: Mon, 25 Sep 2017 22:48:19 +0000
Message-ID: <1506379698.2641.48.camel@wdc.com>
References: <20170922221405.22091-1-bart.vanassche@wdc.com>
         <20170922221405.22091-2-bart.vanassche@wdc.com>
         <20170925023804.GD6434@ming.t460p> <1506356548.2641.13.camel@wdc.com>
         <20170925224526.GA18137@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925224526.GA18137@ming.t460p>
Content-Language: en-US
Content-ID: <72CFF67AF63A6F45A3C41345C2435A49@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gVHVlLCAyMDE3LTA5LTI2IGF0IDA2OjQ1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
TW9uLCBTZXAgMjUsIDIwMTcgYXQgMDQ6MjI6MjlQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIE1vbiwgMjAxNy0wOS0yNSBhdCAxMDozOCArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBPbiBGcmksIFNlcCAyMiwgMjAxNyBhdCAwMzoxNDowMFBNIC0wNzAwLCBCYXJ0
IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gPiA+IFNvbWUgcGVvcGxlIHVzZSB0aGUgbWQgZHJpdmVy
IG9uIGxhcHRvcHMgYW5kIHVzZSB0aGUgc3VzcGVuZCBhbmQNCj4gPiA+ID4gcmVzdW1lIGZ1bmN0
aW9uYWxpdHkuIFNpbmNlIGl0IGlzIGVzc2VudGlhbCB0aGF0IHN1Ym1pdHRpbmcgb2YNCj4gPiA+
ID4gbmV3IEkvTyByZXF1ZXN0cyBzdG9wcyBiZWZvcmUgZGV2aWNlIHF1aWVzY2luZyBzdGFydHMs
IG1ha2UgdGhlDQo+ID4gPiA+IG1kIHJlc3luYyBhbmQgcmVzaGFwZSB0aHJlYWRzIGZyZWV6YWJs
ZS4NCj4gPiA+IA0KPiA+ID4gV2h5IGlzIHRoaXMgcGF0Y2ggcGFydCBvZiB0aGlzIHBhdGNoc2V0
PyBJIGRvbid0IHRoaW5rDQo+ID4gPiBNRCBpcyBzcGVjaWFsIGVub3VnaCB3cnQuIHRoZSBTQ1NJ
IHF1aWVzY2UgaXNzdWUuDQo+ID4gDQo+ID4gQmVjYXVzZSB0aGUgc2NvcGUgb2YgdGhpcyBwYXRj
aCBzZXJpZXMgaXMgbm90IG9ubHkgdG8gbWFrZSBTQ1NJIHF1aWVzY2Ugc2FmZQ0KPiA+IGJ1dCBh
bHNvIHRvIGF2b2lkIHRoYXQgc3VzcGVuZCBhbmQgcmVzdW1lIGxvY2sgdXAgd2l0aCBhIHN0b3Jh
Z2Ugc3RhY2sgdGhhdA0KPiA+IHVzZXMgdGhlIG1kIGRyaXZlci4NCj4gDQo+IElmIFNDU0kgcXVp
ZXNjZSBpcyBzYWZlLCB0aGVyZSBzaG91bGRuJ3QgYmUgc3VzcGVuZC9yZXN1bWUgbG9ja3VwIG9u
IGFueQ0KPiBTQ1NJIGRldmljZSB3cnQuIHF1aWVzY2UsIHJpZ2h0Pw0KDQpQbGVhc2UgcmVyZWFk
IG15IGUtbWFpbC4gWW91IG1pc3JlYWQgaXQuIEkgZGlkbid0IHdyaXRlIHRoYXQgU0NTSSBxdWll
c2NlIGlzIHNhZmUuDQoNCkJhcnQu
