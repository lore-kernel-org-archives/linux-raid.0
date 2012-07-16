From: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 2/2] raid5: For write performance, remove REQ_SYNC when write was odirect.
Date: Mon, 16 Jul 2012 15:11:29 +0800
Message-ID: <201207161511247039289@gmail.com>
References: <201207160931507187344@gmail.com> <20120716154010.0ef12c57@notabene.brown> <201207161442513597497@gmail.com>,
	<20120716170717.5d5ee04c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

T24gMjAxMi0wNy0xNiAxNTowNyBOZWlsQnJvd24gPG5laWxiQHN1c2UuZGU+IFdyb3RlOg0KPk9u
IE1vbiwgMTYgSnVsIDIwMTIgMTQ6NDI6NTQgKzA4MDAgbWFqaWFucGVuZyA8bWFqaWFucGVuZ0Bn
bWFpbC5jb20+IHdyb3RlOg0KPg0KPj4gT24gMjAxMi0wNy0xNiAxMzo0MCBOZWlsQnJvd24gPG5l
aWxiQHN1c2UuZGU+IFdyb3RlOg0KPj4gPk9uIE1vbiwgMTYgSnVsIDIwMTIgMDk6MzE6NTUgKzA4
MDAgbWFqaWFucGVuZyA8bWFqaWFucGVuZ0BnbWFpbC5jb20+IHdyb3RlOg0KPj4gPg0KW3NuaXBd
DQo+PiA+IE5vcm1hbCAnc3luYycgcmVxdWVzdHMgdXNlIFdSSVRFX1NZTkMgd2hpY2ggaW5jbHVk
ZXMgIlJFUV9OT0lETEUiIHdoaWNoIG1lYW5zDQo+PiA+ICAgLyogZG9uJ3QgYW50aWNpcGF0ZSBt
b3JlIElPIGFmdGVyIHRoaXMgb25lICovDQo+PiA+IE9fRElSRUNUIHJlcXVlc3QgdXNlIFdSSVRF
X09ESVJFQ1Qgd2hpY2ggZG9lcyBub3QgaW5jbHVkZSB0aGlzIGZsYWcuDQo+PiA+DQo+DQo+PiBV
c2luZyBSRVFfTk9JREVMIHRvIGRpZmZlcmVuY2Ugb2RpcmVjdCBhbmQgc3luYy5XaHkgbm90IHVz
aW5nOg0KPj4gICsJaWYgKGJpLT5iaV9ydyAmIFdSSVRFX09ESVJFQ1QpDQo+PiAgKwkJYmktPmJp
X3J3ICY9IH5SRVFfU1lOQzsNCj4NCj5CZWNhdXNlIHRoYXQgY29kZSBpcyB3cm9uZy4gIFdSSVRF
X09ESVJFQ1QgaXMgbm90IG9uZSBmbGFnLCBpdCBpcyB0d28gZmxhZ3MNCj4nb3InZWQgdG9nZXRo
ZXIuICBTbyB0aGlzIGNvZGUgZG9lcyBub3QgZG8gd2hhdCB5b3UgZXhwZWN0Lg0KPg0KTm8sIEkg
dXNlZCB0aG9zZSBjb2RlIHRlc3QgYW5kIGl0J3Mgb2suDQpUaGUgY29kZSB1c2VkICYgbm90ICYm
Lg0KTWF5YmUgSSB3cm9uZz8NCj4NCj4+IA0KW3NuaXBd

