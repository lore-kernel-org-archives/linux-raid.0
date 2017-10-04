From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v5 2/8] md: Neither resync nor reshape while the system is
 frozen
Date: Wed, 4 Oct 2017 16:58:33 +0000
Message-ID: <1507136311.3583.35.camel@wdc.com>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
         <20171002225218.18548-3-bart.vanassche@wdc.com>
         <20171004011610.GP2294@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171004011610.GP2294@wotan.suse.de>
Content-Language: en-US
Content-ID: <A9136D4B40129C47A6513B34B775895D@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gV2VkLCAyMDE3LTEwLTA0IGF0IDAzOjE2ICswMjAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gT24gTW9uLCBPY3QgMDIsIDIwMTcgYXQgMDM6NTI6MTJQTSAtMDcwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJz
L21kL21kLmMNCj4gPiBpbmRleCAzZjc0MjYxMjBhM2IuLmEyY2YyYTkzYjBjYiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL21kL21kLmMNCj4gPiArKysgYi9kcml2ZXJzL21kL21kLmMNCj4gPiBA
QCAtODk2MSw2ICs4OTYzLDM3IEBAIHN0YXRpYyB2b2lkIG1kX3N0b3BfYWxsX3dyaXRlcyh2b2lk
KQ0KPiA+ICAJCW1kZWxheSgxMDAwKjEpOw0KPiA+ICB9DQo+ID4gIA0KPiA+ICsvKg0KPiA+ICsg
KiBFbnN1cmUgdGhhdCBuZWl0aGVyIHJlc3luY2luZyBub3IgcmVzaGFwaW5nIG9jY3VycyB3aGls
ZSB0aGUgc3lzdGVtIGlzDQo+ID4gKyAqIGZyb3plbi4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBp
bnQgbWRfbm90aWZ5X3BtKHN0cnVjdCBub3RpZmllcl9ibG9jayAqYmwsIHVuc2lnbmVkIGxvbmcg
c3RhdGUsDQo+ID4gKwkJCXZvaWQgKnVudXNlZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IG1kZGV2
ICptZGRldjsNCj4gPiArCXN0cnVjdCBsaXN0X2hlYWQgKnRtcDsNCj4gPiArDQo+ID4gKwlwcl9k
ZWJ1ZygiJXM6IHN0YXRlID0gJWxkOyBzeXN0ZW1fZnJlZXppbmdfY250ID0gJWRcbiIsIF9fZnVu
Y19fLCBzdGF0ZSwNCj4gPiArCQkgYXRvbWljX3JlYWQoJnN5c3RlbV9mcmVlemluZ19jbnQpKTsN
Cj4gPiArDQo+ID4gKwlzd2l0Y2ggKHN0YXRlKSB7DQo+ID4gKwljYXNlIFBNX0hJQkVSTkFUSU9O
X1BSRVBBUkU6DQo+IA0KPiBIbSwgd2h5IG5vdCBhbHNvIGluY2x1ZGUgYW5kIHVzZSB0aGlzIGZv
ciBQTV9TVVNQRU5EX1BSRVBBUkUgYW5kL29yDQo+IGEgUE1fUkVTVE9SRV9QUkVQQVJFLg0KPiAN
Cj4gICAgICAgICBjYXNlIFBNX0hJQkVSTkFUSU9OX1BSRVBBUkU6DQo+ICAgICAgICAgY2FzZSBQ
TV9TVVNQRU5EX1BSRVBBUkU6DQo+ICAgICAgICAgY2FzZSBQTV9SRVNUT1JFX1BSRVBBUkU6DQoN
ClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrIEx1aXMuIEkgd2lsbCBtYWtlIHN1cmUgdGhhdCByZXN5
bmMgYWN0aXZpdHkgaXMgYWxzbw0Kc3RvcHBlZCBmb3IgdGhlIFBNX1NVU1BFTkRfUFJFUEFSRSBh
bmQgUE1fUkVTVE9SRV9QUkVQQVJFIGNhc2VzLg0KDQpCYXJ0Lg==
