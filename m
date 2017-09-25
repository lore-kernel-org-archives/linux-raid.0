From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v3 1/6] md: Make md resync and reshape threads freezable
Date: Mon, 25 Sep 2017 16:22:29 +0000
Message-ID: <1506356548.2641.13.camel@wdc.com>
References: <20170922221405.22091-1-bart.vanassche@wdc.com>
         <20170922221405.22091-2-bart.vanassche@wdc.com>
         <20170925023804.GD6434@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925023804.GD6434@ming.t460p>
Content-Language: en-US
Content-ID: <CF7061553DD2864FB420D2D7ADC41B86@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDEwOjM4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
RnJpLCBTZXAgMjIsIDIwMTcgYXQgMDM6MTQ6MDBQTSAtMDcwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IFNvbWUgcGVvcGxlIHVzZSB0aGUgbWQgZHJpdmVyIG9uIGxhcHRvcHMgYW5kIHVz
ZSB0aGUgc3VzcGVuZCBhbmQNCj4gPiByZXN1bWUgZnVuY3Rpb25hbGl0eS4gU2luY2UgaXQgaXMg
ZXNzZW50aWFsIHRoYXQgc3VibWl0dGluZyBvZg0KPiA+IG5ldyBJL08gcmVxdWVzdHMgc3RvcHMg
YmVmb3JlIGRldmljZSBxdWllc2Npbmcgc3RhcnRzLCBtYWtlIHRoZQ0KPiA+IG1kIHJlc3luYyBh
bmQgcmVzaGFwZSB0aHJlYWRzIGZyZWV6YWJsZS4NCj4gDQo+IFdoeSBpcyB0aGlzIHBhdGNoIHBh
cnQgb2YgdGhpcyBwYXRjaHNldD8gSSBkb24ndCB0aGluaw0KPiBNRCBpcyBzcGVjaWFsIGVub3Vn
aCB3cnQuIHRoZSBTQ1NJIHF1aWVzY2UgaXNzdWUuDQoNCkJlY2F1c2UgdGhlIHNjb3BlIG9mIHRo
aXMgcGF0Y2ggc2VyaWVzIGlzIG5vdCBvbmx5IHRvIG1ha2UgU0NTSSBxdWllc2NlIHNhZmUNCmJ1
dCBhbHNvIHRvIGF2b2lkIHRoYXQgc3VzcGVuZCBhbmQgcmVzdW1lIGxvY2sgdXAgd2l0aCBhIHN0
b3JhZ2Ugc3RhY2sgdGhhdA0KdXNlcyB0aGUgbWQgZHJpdmVyLg0KDQpCYXJ0Lg==
