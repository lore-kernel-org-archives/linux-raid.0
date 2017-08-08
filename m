From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 0/5] block: a virtual block device driver for testing
Date: Tue, 8 Aug 2017 22:00:21 +0000
Message-ID: <1502229619.2686.1.camel@wdc.com>
References: <cover.1501945859.git.shli@fb.com>
         <42bfcce1-8329-c0df-7457-107b388491ff@suse.de>
         <20170807163607.msflun2r4q5tlpsk@kernel.org>
         <f6896ce5-1752-feba-fadb-dbc89dbf4e20@kernel.dk>
         <20170808210507.setdwunzrad4t7xp@kernel.org>
         <73342715-25af-da8e-ae7e-f24015432055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73342715-25af-da8e-ae7e-f24015432055@kernel.dk>
Content-Language: en-US
Content-ID: <B9D50CBE682785448F04C169517ACE0C@namprd04.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: "shli@kernel.org" <shli@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "kernel-team@fb.com" <kernel-team@fb.com>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kyungchan.koh@gmail.com" <kyungchan.koh@gmail.com>, "shli@fb.com" <shli@fb.com>
List-Id: linux-raid.ids

T24gVHVlLCAyMDE3LTA4LTA4IGF0IDE1OjEzIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAwOC8wOC8yMDE3IDAzOjA1IFBNLCBTaGFvaHVhIExpIHdyb3RlOg0KPiA+ID4gSSdtIGN1cmlv
dXMgd2h5IG51bGxfYmxrIGlzbid0IGEgZ29vZCBmaXQ/IFlvdSdkIGp1c3QgbmVlZCB0byBhZGQg
UkFNDQo+ID4gPiBzdG9yYWdlIHRvIGl0LiBUaGF0IHdvdWxkIGp1c3QgYmUgYSBzZXBhcmF0ZSBv
cHRpb24gdGhhdCBzaG91bGQgYmUNCj4gPiA+IHNldCwNCj4gPiA+IHJhbV9iYWNraW5nPTEgb3Ig
c29tZXRoaW5nIGxpa2UgdGhhdC4gVGhhdCB3b3VsZCBtYWtlIGl0IGxlc3MgY3JpdGljYWwNCj4g
PiA+IHRoYW4gdXNpbmcgdGhlIFJBTSBkaXNrIGRyaXZlciBhcyB3ZWxsLCBzaW5jZSBvbmx5IHBl
b3BsZSB0aGF0IHdhbnQgYQ0KPiA+ID4gInJlYWwiDQo+ID4gPiBkYXRhIGJhY2tpbmcgd291bGQg
ZW5hYmxlIGl0Lg0KPiA+ID4gDQo+ID4gPiBJdCdzIG5vdCB0aGF0IEknbSBleHRyZW1lbHkgb3Bw
b3NlZCB0byBhZGRpbmcgYShub3RoZXIpIHRlc3QgYmxvY2sNCj4gPiA+IGRyaXZlciwNCj4gPiA+
IGJ1dCB3ZSBhdCBsZWFzdCBuZWVkIHNvbWUgc29ydCBvZiByZWFzb25pbmcgYmVoaW5kIHdoeSwg
d2hpY2ggaXNuJ3QNCj4gPiA+IGp1c3QNCj4gPiA+ICJub3QgYSBnb29kIGZpdCIuDQo+ID4gDQo+
ID4gQWgsIEkgdGhvdWdodCB0aGUgJ251bGwnIG9mIG51bGxfYmxrIG1lYW5zIHdlIGRvIG5vdGhp
bmcgZm9yIHRoZQ0KPiA+IGRpc2tzLiBPZiBjb3Vyc2Ugd2UgY2FuIHJlbmFtZSBpdCwgd2hpY2gg
bWVhbnMgdGhpcyBwb2ludCBsZXNzDQo+ID4gbWVhbmluZ2Z1bC4gSSB0aGluayB0aGUgbWFpbiBy
ZWFzb24gaXMgdGhlIGludGVyZmFjZS4gV2Ugd2lsbA0KPiA+IGNvbmZpZ3VyZSB0aGUgZGlza3Mg
d2l0aCBkaWZmZXJlbnQgcGFyYW1ldGVycyBhbmQgZG8gcG93ZXIgb24vb2ZmIGZvcg0KPiA+IGVh
Y2ggZGlza3MgKHdoaWNoIGlzIHRoZSBrZXkgd2UgY2FuIGVtdWxhdGUgZGlzayBjYWNoZSBhbmQg
cG93ZXINCj4gPiBsb3NzKS4gVGhlIG1vZHVsZSBwYXJhbXRlciBpbnRlcmZhY2Ugb2YgbnVsbF9i
bGsgZG9lc24ndCB3b3JrIGZvciB0aGUNCj4gPiB1c2FnZS4gT2YgY291cnNlLCB0aGVzZSBpc3N1
ZXMgY2FuIGJlIGZpeGVkLCBmb3IgZXhhbXBsZSwgd2UgY2FuIG1ha2UNCj4gPiBudWxsX2JsayB1
c2UgdGhlIGNvbmZpZ2ZzIGludGVyZmFjZS4gSWYgeW91IHJlYWxseSBwcmVmZXIgYSBzaW5nbGUN
Cj4gPiBkcml2ZXIgZm9yIGFsbCB0ZXN0IHB1cnBvc2UsIEkgY2FuIG1vdmUgdGhlIHRlc3RfYmxr
IGZ1bmN0aW9uYWxpdGllcw0KPiA+IHRvIG51bGxfYmxrLg0KPiANCj4gVGhlIGlkZWEgd2l0aCBu
dWxsX2JsayBpcyBqdXN0IHRoYXQgaXQncyBhIHRlc3QgdmVoaWNsZS4gQXMgc3VjaCwgaXQNCj4g
d291bGQgYWN0dWFsbHkgYmUgdXNlZnVsIHRvIGhhdmUgYSBtb2RlIHdoZXJlIGl0IGRvZXMgc3Rv
cmUgdGhlIGRhdGEgaW4NCj4gUkFNLCBzaW5jZSB0aGF0IGVuYWJsZXMgeW91IHRvIGRvIG90aGVy
IGtpbmRzIG9mIHRlc3RpbmcgYXMgd2VsbC4gSSdkIGJlDQo+IGZpbmUgd2l0aCBhdWdtZW50aW5n
IGl0IHdpdGggY29uZmlnZnMgZm9yIGNlcnRhaW4gdGhpbmdzLg0KDQpIZWxsbyBKZW5zLA0KDQpX
b3VsZCB5b3UgY29uc2lkZXIgaXQgYWNjZXB0YWJsZSB0byBtYWtlIHRoZSBtb2RlIGluIHdoaWNo
IG51bGxfYmxrIHN0b3Jlcw0KZGF0YSB0aGUgZGVmYXVsdD8gSSBrbm93IHNldmVyYWwgcGVvcGxl
IHdobyBnb3QgY29uZnVzZWQgYnkgbnVsbF9ibGsgYnkNCmRlZmF1bHQgbm90IHJldGFpbmluZyBk
YXRhIC4uLg0KDQpUaGFua3MsDQoNCkJhcnQu
