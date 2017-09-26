From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 14:40:36 +0000
Message-ID: <1506436834.3787.22.camel@wdc.com>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
         <20170925202924.16603-2-bart.vanassche@wdc.com>
         <20170925230421.GD18137@ming.t460p> <1506380954.2641.57.camel@wdc.com>
         <20170926040103.GA19111@ming.t460p> <20170926081309.GA518@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170926081309.GA518@ming.t460p>
Content-Language: en-US
Content-ID: <50869ADEC6D5A0418DA74BF3337BF879@namprd04.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

T24gVHVlLCAyMDE3LTA5LTI2IGF0IDE2OjEzICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSSBh
bSBwcmV0dHkgc3VyZSB0aGF0IHN1c3BlbmQvcmVzdW1lIGNhbiBzdXJ2aXZlIHdoZW4gcmVzeW5j
IGluIHByb2dyZXNzDQo+IHdpdGggbXkgcGF0Y2hzZXQgYXBwbGllZCBvbiBSQUlEMSwgd2l0aG91
dCBhbnkgTUQgY2hhbmdlLg0KDQpUaGUgYWJvdmUgc2hvd3MgdGhhdCB5b3UgZG8gbm90IHVuZGVy
c3RhbmQgaG93IHN1c3BlbmQgYW5kIHJlc3VtZSB3b3Jrcy4NCkluIHRoZSBkb2N1bWVudHMgaW4g
dGhlIGRpcmVjdG9yeSBEb2N1bWVudGF0aW9uL3Bvd2VyIGl0IGlzIGV4cGxhaW5lZCBjbGVhcmx5
DQp0aGF0IEkvTyBtdXN0IGJlIHN0b3BwZWQgYmVmb3JlIHRoZSBoaWJlcm5hdGlvbiBpbWFnZSBp
cyBnZW5lcmF0aW9uIHRvIGF2b2lkDQpoYXJkIHRvIHJlcGFpciBmaWxlc3lzdGVtIGNvcnJ1cHRp
b24uIEFsdGhvdWdoIG1kIGlzIG5vdCBhIGZpbGVzeXN0ZW0gSSB0aGluaw0KdGhpcyBhbHNvIGFw
cGxpZXMgdG8gbWQgc2luY2UgbWQga2VlcHMgc29tZSBzdGF0ZSBpbmZvcm1hdGlvbiBpbiBSQU0g
YW5kIHNvbWUNCnN0YXRlIGluZm9ybWF0aW9uIG9uIGRpc2suIEl0IGlzIGVzc2VudGlhbCB0aGF0
IGFsbCB0aGF0IHN0YXRlIGluZm9ybWF0aW9uIGlzDQppbiBjb25zaXN0ZW50Lg0KDQo+IElmIHlv
dXIgcGF0Y2hzZXQgZGVwZW5kcyBvbiB0aGlzIE1EIGNoYW5nZSwgc29tZXRoaW5nIHNob3VsZCBi
ZSB3cm9uZw0KPiBpbiB0aGUgZm9sbG93aW5nIHBhdGNoZXMuIE5vdyBJIG5lZWQgdG8gdGFrZSBh
IGNsb3NlIGxvb2suDQoNClRoZSBsYXRlciBwYXRjaGVzIHRoYXQgbWFrZSBTQ1NJIHF1aWVzY2Ug
YW5kIHJlc3VtZSBzYWZlIGRvIG5vdCBkZXBlbmQgb24NCnRoaXMgY2hhbmdlLg0KDQpCYXJ0Lg==
