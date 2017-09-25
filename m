From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Mon, 25 Sep 2017 23:09:15 +0000
Message-ID: <1506380954.2641.57.camel@wdc.com>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
         <20170925202924.16603-2-bart.vanassche@wdc.com>
         <20170925230421.GD18137@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170925230421.GD18137@ming.t460p>
Content-Language: en-US
Content-ID: <904C4EA24CF5CD40AB24447A188C66E3@namprd04.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gVHVlLCAyMDE3LTA5LTI2IGF0IDA3OjA0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
TW9uLCBTZXAgMjUsIDIwMTcgYXQgMDE6Mjk6MThQTSAtMDcwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IFNvbWUgcGVvcGxlIHVzZSB0aGUgbWQgZHJpdmVyIG9uIGxhcHRvcHMgYW5kIHVz
ZSB0aGUgc3VzcGVuZCBhbmQNCj4gPiByZXN1bWUgZnVuY3Rpb25hbGl0eS4gU2luY2UgaXQgaXMg
ZXNzZW50aWFsIHRoYXQgc3VibWl0dGluZyBvZg0KPiA+IG5ldyBJL08gcmVxdWVzdHMgc3RvcHMg
YmVmb3JlIGRldmljZSBxdWllc2Npbmcgc3RhcnRzLCBtYWtlIHRoZQ0KPiA+IG1kIHJlc3luYyBh
bmQgcmVzaGFwZSB0aHJlYWRzIGZyZWV6YWJsZS4NCj4gDQo+IEFzIEkgZXhwbGFpbmVkLCBpZiBT
Q1NJIHF1aWVzY2UgaXMgc2FmZSwgdGhpcyBwYXRjaCBzaG91bGRuJ3QNCj4gYmUgbmVlZGVkLg0K
PiANCj4gVGhlIGlzc3VlIGlzbid0IE1EIHNwZWNpZmljLCBhbmQgaW4gdGhlb3J5IGNhbiBiZSB0
cmlnZ2VyZWQNCj4gb24gYWxsIGRldmljZXMuIEFuZCB5b3UgY2FuIHNlZSB0aGUgSS9PIGhhbmcg
cmVwb3J0IG9uIEJUUkZTKFJBSUQpDQo+IHdpdGhvdXQgTUQgaW52b2x2ZWQ6DQo+IA0KPiAJaHR0
cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtYmxvY2smbT0xNTA2MzQ4ODM4MTY5NjUmdz0yDQoNCldo
YXQgbWFrZXMgeW91IHRoaW5rIHRoYXQgdGhpcyBwYXRjaCBpcyBub3QgbmVjZXNzYXJ5IG9uY2Ug
U0NTSSBxdWllc2NlDQpoYXMgYmVlbiBtYWRlIHNhZmU/IERvZXMgdGhpcyBtZWFuIHRoYXQgeW91
IGhhdmUgbm90IHRlc3RlZCBzdXNwZW5kIGFuZA0KcmVzdW1lIHdoaWxlIG1kIFJBSUQgMSByZXN5
bmMgd2FzIGluIHByb2dyZXNzPyBUaGlzIHBhdGNoIGlzIG5lY2Vzc2FyeQ0KdG8gYXZvaWQgdGhh
dCBzdXNwZW5kIGxvY2tzIHVwIHdoaWxlIG1kIFJBSUQgMSByZXN5bmMgaXMgaW4gcHJvZ3Jlc3Mu
DQoNCkJhcnQu
