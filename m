From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v5 2/8] md: Neither resync nor reshape while the system is
 frozen
Date: Wed, 4 Oct 2017 15:38:25 +0000
Message-ID: <1507131503.3583.24.camel@wdc.com>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
         <20171002225218.18548-3-bart.vanassche@wdc.com>
         <20171004113021.GC17729@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171004113021.GC17729@ming.t460p>
Content-Language: en-US
Content-ID: <431F38D50B172B459577AE2B836B2748@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gV2VkLCAyMDE3LTEwLTA0IGF0IDE5OjMwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTGFz
dCB0aW1lLCBJIGFza2VkIHdoaWNoIGlzc3VlIGlzIGZpeGVkIGJ5IHRoaXMgcGF0Y2gsIGJ1dA0K
PiBuZXZlciBnZXQgYW5zd2VyZWQsIHNvIGFnYWluLCB3aGF0IGlzIGlzc3VlIGZpeGVkIGJ5DQo+
IHRoaXMgcGF0Y2g/DQoNClRoYXQncyBub3QgY29ycmVjdC4gSSBkaWQgYW5zd2VyIHlvdXIgcXVl
c3Rpb24uIFNlZSBlLmcuDQpodHRwczovL21hcmMuaW5mby8/bD1saW51eC1ibG9jayZtPTE1MDY5
NTg3OTMwOTYwNi4NCg0KPiBHaXZlbiB0aGUgZm9sbG93aW5nIHBhdGNoZXMgZm9yIG1ha2luZyBT
Q1NJIHF1aWVzY2Ugc2FmZQ0KPiBpcyByZXF1aXJlZCBpbiBlaXRoZXIgUE0gc3VzcGVuZC9yZXN1
bWUgb3Igb3RoZXIgcGF0aA0KPiBvZiB0cmFuc3BvcnRfc3BpIHJldmFsaWRhdGUuIFNvIG9uY2Ug
dGhlc2VzIHBhdGNoZXMgYXJlDQo+IGluLCBJIGRvbid0IHNlZSBhbnkgSS9PIGhhbmcgaW4gc3Vz
cGVuZC9yZXN1bWUgZ2l2ZW4NCj4gdGhlIFNDU0kgcXVpZXNjZSBpc3N1ZSBpcyB2ZXJ5IHNwZWNp
ZmljIG9uZSwgYW5kIG5vdA0KPiBzZWUgdGhpcyBpc3N1ZSBvbiBvdGhlciBraW5kIG9mIGRldmlj
ZS4NCg0KVGhlcmUgYXJlIG1hbnkgbW9yZSBzdG9yYWdlIGRyaXZlcnMgYW5kIGZpbGVzeXN0ZW1z
IHRoYW4gdGhlIG1kIGRyaXZlciB0aGF0DQpjYW4gc3VibWl0IEkvTyBhZnRlciB1c2VyIHNwYWNl
IHByb2Nlc3NlcyBoYXZlIGJlZW4gZnJvemVuLCBlLmcuIHRoZSBCVFJGUw0KUkFJRCBhbmQgc2Ny
dWIgZnVuY3Rpb25hbGl0aWVzLiBJdCB3aWxsIHRha2UgdGltZSB0byBmaXggYWxsIHRoZXNlIGRy
aXZlcnMNCmFuZCBhbHNvIHRvIGFkZCBmaWxlc3lzdGVtIGZyZWV6ZS90aGF3IGZ1bmN0aW9uYWxp
dHkgdG8gdGhlIHN1c3BlbmQgYW5kDQpyZXN1bWUgc2VxdWVuY2VzLiBBcyBsb25nIGFzIG5vdCBh
bGwgZHJpdmVycyBoYXZlIGJlZW4gZml4ZWQgd2Ugd2lsbCBuZWVkDQpTQ1NJIGRldmljZSBxdWll
c2NpbmcgYW5kIHJlc3VtaW5nIGFzIGEgd29ya2Fyb3VuZCB0byBhdm9pZCB0aGF0IGFueSBJL08N
Cm9jY3VycyB3aGlsZSBhIGhpYmVybmF0aW9uIGltYWdlIGlzIGJlaW5nIGNyZWF0ZWQuDQoNCkJh
cnQu
