From: Josh Litherland <josh@emperorlinux.com>
Subject: [PATCH] XOR template selection redo
Date: Mon, 21 Jun 2004 11:26:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1087831588.3094.10.camel@JubJub>
Reply-To: josh@emperorlinux.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JiSUfz0hrNtMC8UuOeQJ"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: research@emperorlinux.com
List-Id: linux-raid.ids


--=-JiSUfz0hrNtMC8UuOeQJ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Okay, due to my wonky printk's the previous patch was pretty lousy at
its stated purpose of reducing confusion.  Attached is a better
version.  I tried to keep output mostly consistant, so:


raid5: measuring checksumming speed
   8regs     :  1900.000 MB/sec
   8regs_prefetch:  2396.000 MB/sec
   32regs    :  1652.000 MB/sec
   32regs_prefetch:  1700.000 MB/sec
   pIII_sse  :  1904.000 MB/sec
   pII_mmx   :  4696.000 MB/sec
   p5_mmx    :  6252.000 MB/sec
raid5: using function: p5_mmx (6252.000 MB/sec)

and

raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  2280.000 MB/sec
raid5: using function: pIII_sse (2280.000 MB/sec)

-- 
Josh Litherland <josh@emperorlinux.com>
Emperor Linux

--=-JiSUfz0hrNtMC8UuOeQJ
Content-Disposition: attachment; filename=xor-selection-good.diff
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=xor-selection-good.diff; charset=us-ascii

ZGlmZiAtZHJhdU4gbGludXgtMi42LjcvZHJpdmVycy9tZC94b3IuYyBsaW51eC0yLjYuNy5uZXcv
ZHJpdmVycy9tZC94b3IuYw0KLS0tIGxpbnV4LTIuNi43L2RyaXZlcnMvbWQveG9yLmMJMjAwNC0w
Ni0xNiAwMToxOToyMy4wMDAwMDAwMDAgLTA0MDANCisrKyBsaW51eC0yLjYuNy5uZXcvZHJpdmVy
cy9tZC94b3IuYwkyMDA0LTA2LTIxIDExOjA4OjMzLjAwMDAwMDAwMCAtMDQwMA0KQEAgLTEwOCwy
OSArMTA4LDQwIEBADQogCX0NCiAJYjIgPSBiMSArIDIqUEFHRV9TSVpFICsgQkVOQ0hfU0laRTsN
CiANCi0JcHJpbnRrKEtFUk5fSU5GTyAicmFpZDU6IG1lYXN1cmluZyBjaGVja3N1bW1pbmcgc3Bl
ZWRcbiIpOw0KKwkvKg0KKwkgKiBJZiB0aGlzIGFyY2gvY3B1IGhhcyBhIHNob3J0LWNpcmN1aXRl
ZCBzZWxlY3Rpb24sIGRvbid0IGxvb3AgdGhyb3VnaCBhbGwNCisJICogdGhlIHBvc3NpYmxlIGZ1
bmN0aW9ucywganVzdCB0ZXN0IHRoZSBiZXN0IG9uZQ0KKwkgKi8NCiANCisJZmFzdGVzdCA9IE5V
TEw7DQorDQorI2lmZGVmIFhPUl9TRUxFQ1RfVEVNUExBVEUNCisJCWZhc3Rlc3QgPSBYT1JfU0VM
RUNUX1RFTVBMQVRFKGZhc3Rlc3QpOw0KKyNlbmRpZg0KKwkNCiAjZGVmaW5lIHhvcl9zcGVlZCh0
ZW1wbCkJZG9feG9yX3NwZWVkKCh0ZW1wbCksIGIxLCBiMikNCiANCi0JWE9SX1RSWV9URU1QTEFU
RVM7DQorCWlmIChmYXN0ZXN0KSB7DQorCQlwcmludGsoS0VSTl9JTkZPICJyYWlkNTogYXV0b21h
dGljYWxseSB1c2luZyBiZXN0IGNoZWNrc3VtbWluZyBmdW5jdGlvbjogJXNcbiIsDQorCQkJZmFz
dGVzdC0+bmFtZSk7DQorCQl4b3Jfc3BlZWQoZmFzdGVzdCk7DQorCX0gZWxzZSB7DQorCQlwcmlu
dGsoS0VSTl9JTkZPICJyYWlkNTogbWVhc3VyaW5nIGNoZWNrc3VtbWluZyBzcGVlZFxuIik7DQor
CQlYT1JfVFJZX1RFTVBMQVRFUzsNCisJCWZhc3Rlc3QgPSB0ZW1wbGF0ZV9saXN0Ow0KKwkJZm9y
IChmID0gZmFzdGVzdDsgZjsgZiA9IGYtPm5leHQpIA0KKwkJCWlmIChmLT5zcGVlZCA+IGZhc3Rl
c3QtPnNwZWVkKQ0KKwkJCQlmYXN0ZXN0ID0gZjsNCisJfQ0KKw0KKwlwcmludGsoInJhaWQ1OiB1
c2luZyBmdW5jdGlvbjogJXMgKCVkLiUwM2QgTUIvc2VjKVxuIiwNCisJICAgICAgIGZhc3Rlc3Qt
Pm5hbWUsIGZhc3Rlc3QtPnNwZWVkIC8gMTAwMCwgZmFzdGVzdC0+c3BlZWQgJSAxMDAwKTsNCiAN
CiAjdW5kZWYgeG9yX3NwZWVkDQogDQogCWZyZWVfcGFnZXMoKHVuc2lnbmVkIGxvbmcpYjEsIDIp
Ow0KIA0KLQlmYXN0ZXN0ID0gdGVtcGxhdGVfbGlzdDsNCi0JZm9yIChmID0gZmFzdGVzdDsgZjsg
ZiA9IGYtPm5leHQpDQotCQlpZiAoZi0+c3BlZWQgPiBmYXN0ZXN0LT5zcGVlZCkNCi0JCQlmYXN0
ZXN0ID0gZjsNCi0NCi0jaWZkZWYgWE9SX1NFTEVDVF9URU1QTEFURQ0KLQlmYXN0ZXN0ID0gWE9S
X1NFTEVDVF9URU1QTEFURShmYXN0ZXN0KTsNCi0jZW5kaWYNCi0NCiAJYWN0aXZlX3RlbXBsYXRl
ID0gZmFzdGVzdDsNCi0JcHJpbnRrKCJyYWlkNTogdXNpbmcgZnVuY3Rpb246ICVzICglZC4lMDNk
IE1CL3NlYylcbiIsDQotCSAgICAgICBmYXN0ZXN0LT5uYW1lLCBmYXN0ZXN0LT5zcGVlZCAvIDEw
MDAsIGZhc3Rlc3QtPnNwZWVkICUgMTAwMCk7DQotDQogCXJldHVybiAwOw0KIH0NCiANCg==

--=-JiSUfz0hrNtMC8UuOeQJ--
