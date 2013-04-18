From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] imsm: monitor: do not finish migration if there are no
 failed disks
Date: Thu, 18 Apr 2013 11:26:09 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB19A53D34@IRSMSX102.ger.corp.intel.com>
References: <20130418085136.8837.86343.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418085136.8837.86343.stgit@localhost.localdomain>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>, "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

T24gVGh1cnNkYXksIEFwcmlsIDE4LCAyMDEzIDEwOjUyIEFNIEJhbGR5c2lhaywgUGF3ZWwgPHBh
d2VsLmJhbGR5c2lha0BpbnRlbC5jb20+IHdyb3RlOg0KPiBGcm9tOiBQcnplbXlzbGF3IEN6YXJu
b3dza2kNCj4gPHByemVteXNsYXcuaGF3cnlsZXdpY3ouY3phcm5vd3NraUBpbnRlbC5jb20+DQo+
IA0KPiBUcmFuc2l0aW9uIGZyb20gImRlZ3JhZGVkIiB0byAicmVjb3ZlcnkiIG1hZGUgaW4gT1JP
TSBpcyBzbGlnaHRseSBkaWZmZXJlbnQNCj4gdGhhbiB0aGUgc2FtZSB0cmFuc2lzaW9uIGluIG1k
YWRtLiBNaXNzaW5nIGRpc2sgaXMgbm90IHJlbW92ZWQgZnJvbSBsaXN0IG9mDQo+IHJhaWQgZGV2
aWNlcywgYnV0IGp1c3QgZnJvbSBtYXAuIFRoZXJlZm9yZSBtZGFkbSBzaG91bGQgbm90IGVuZCBt
aWdyYXRpb24NCj4gYmFzaW5nIG9uIGV4aXN0ZW5jZSBvZiBsaXN0IG9mIG1pc3NpbmcgZGlza3Mg
YnV0IHNob3VsZCByZWx5IG9uIGNvdW50IG9mDQo+IGZhaWxlZCBkaXNrcy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFByemVteXNsYXcgQ3phcm5vd3NraQ0KPiA8cHJ6ZW15c2xhdy5oYXdyeWxld2lj
ei5jemFybm93c2tpQGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBQYXdlbCBCYWxkeXNpYWsgPHBh
d2VsLmJhbGR5c2lha0BpbnRlbC5jb20+DQoNCkFkZGluZyBhdXRob3IgKFByemVteXNsYXcgQ3ph
cm5vd3NraSA8cHJ6ZW15c2xhdy5oYXdyeWxld2ljei5jemFybm93c2tpQGludGVsLmNvbT4pIHRv
IENDLg0KDQotLQ0KTHVrYXN6DQo=
