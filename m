From: Josh Litherland <josh@emperorlinux.com>
Subject: [PATCH] Simplify XOR template selection
Date: Sun, 20 Jun 2004 14:47:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1087757251.12410.9.camel@JubJub>
Reply-To: josh@emperorlinux.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-c9zElOBgUej8pXwwNZWX"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: research@emperorlinux.com
List-Id: linux-raid.ids


--=-c9zElOBgUej8pXwwNZWX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I found this output confusing:

raid5: measuring checksumming speed
   8regs     :  1896.000 MB/sec
   8regs_prefetch:  2396.000 MB/sec
   32regs    :  1772.000 MB/sec
   32regs_prefetch:  1664.000 MB/sec
   pIII_sse  :  2352.000 MB/sec
   pII_mmx   :  4696.000 MB/sec
   p5_mmx    :  6252.000 MB/sec
raid5: using function: pIII_sse (2352.000 MB/sec)

since it seemed to be choosing a sub-optimal function.  I read the code
and figured out why this is the way it is.  However, to save others the
same confusion I had, and maybe even save a few picoseconds on startup,
I humbly submit the attached patch.

-- 
Josh Litherland <josh@emperorlinux.com>
Emperor Linux

--=-c9zElOBgUej8pXwwNZWX
Content-Disposition: attachment; filename=xor_selection.diff
Content-Type: text/x-patch; name=xor_selection.diff; charset=us-ascii
Content-Transfer-Encoding: base64

ZGlmZiAtZHJhdU4gbGludXgtMi42LjYvZHJpdmVycy9tZC94b3IuYyBsaW51eC0yLjYuNi5uZXcv
ZHJpdmVycy9tZC94b3IuYw0KLS0tIGxpbnV4LTIuNi42L2RyaXZlcnMvbWQveG9yLmMJMjAwNC0w
NS0wOSAyMjozMjozNy4wMDAwMDAwMDAgLTA0MDANCisrKyBsaW51eC0yLjYuNi5uZXcvZHJpdmVy
cy9tZC94b3IuYwkyMDA0LTA2LTIwIDE0OjI2OjIxLjAwMDAwMDAwMCAtMDQwMA0KQEAgLTEwOCwy
OSArMTA4LDQwIEBADQogCX0NCiAJYjIgPSBiMSArIDIqUEFHRV9TSVpFICsgQkVOQ0hfU0laRTsN
CiANCi0JcHJpbnRrKEtFUk5fSU5GTyAicmFpZDU6IG1lYXN1cmluZyBjaGVja3N1bW1pbmcgc3Bl
ZWRcbiIpOw0KKwkvKg0KKwkgKiBJZiB0aGlzIGFyY2gvY3B1IGhhcyBhIHNob3J0LWNpcmN1aXRl
ZCBzZWxlY3Rpb24sIGRvbid0IGxvb3AgdGhyb3VnaCBhbGwNCisJICogdGhlIHBvc3NpYmxlIGZ1
bmN0aW9ucywganVzdCB0ZXN0IHRoZSBiZXN0IG9uZQ0KKwkgKi8NCiANCisJZmFzdGVzdCA9IE5V
TEw7DQorDQorI2lmZGVmIFhPUl9TRUxFQ1RfVEVNUExBVEUNCisJCWZhc3Rlc3QgPSBYT1JfU0VM
RUNUX1RFTVBMQVRFKGZhc3Rlc3QpOw0KKyNlbmRpZg0KKwkNCiAjZGVmaW5lIHhvcl9zcGVlZCh0
ZW1wbCkJZG9feG9yX3NwZWVkKCh0ZW1wbCksIGIxLCBiMikNCiANCi0JWE9SX1RSWV9URU1QTEFU
RVM7DQorCWlmIChmYXN0ZXN0KSB7DQorCQl4b3Jfc3BlZWQoZmFzdGVzdCk7DQorCQlwcmludGso
IktFUk5fSU5GTyByYWlkNTogYXV0b21hdGljYWxseSB1c2luZyBiZXN0IGNoZWNrc3VtbWluZyBm
dW5jdGlvbjogJXMgKCVkLiUwM2QgTUIvc2VjKVxuIiwNCisJCSAgICAgICBmYXN0ZXN0LT5uYW1l
LCBmYXN0ZXN0LT5zcGVlZCAvIDEwMDAsIGZhc3Rlc3QtPnNwZWVkICUgMTAwMCk7DQorCX0gZWxz
ZSB7DQorCQlwcmludGsoS0VSTl9JTkZPICJyYWlkNTogbWVhc3VyaW5nIGNoZWNrc3VtbWluZyBz
cGVlZFxuIik7DQorCQlYT1JfVFJZX1RFTVBMQVRFUzsNCisJCWZhc3Rlc3QgPSB0ZW1wbGF0ZV9s
aXN0Ow0KKwkJZm9yIChmID0gZmFzdGVzdDsgZjsgZiA9IGYtPm5leHQpIA0KKwkJCWlmIChmLT5z
cGVlZCA+IGZhc3Rlc3QtPnNwZWVkKQ0KKwkJCQlmYXN0ZXN0ID0gZjsNCisJCXByaW50aygicmFp
ZDU6IHVzaW5nIGZ1bmN0aW9uOiAlcyAoJWQuJTAzZCBNQi9zZWMpXG4iLA0KKwkJICAgICAgIGZh
c3Rlc3QtPm5hbWUsIGZhc3Rlc3QtPnNwZWVkIC8gMTAwMCwgZmFzdGVzdC0+c3BlZWQgJSAxMDAw
KTsNCisNCisJfQ0KIA0KICN1bmRlZiB4b3Jfc3BlZWQNCiANCiAJZnJlZV9wYWdlcygodW5zaWdu
ZWQgbG9uZyliMSwgMik7DQogDQotCWZhc3Rlc3QgPSB0ZW1wbGF0ZV9saXN0Ow0KLQlmb3IgKGYg
PSBmYXN0ZXN0OyBmOyBmID0gZi0+bmV4dCkNCi0JCWlmIChmLT5zcGVlZCA+IGZhc3Rlc3QtPnNw
ZWVkKQ0KLQkJCWZhc3Rlc3QgPSBmOw0KLQ0KLSNpZmRlZiBYT1JfU0VMRUNUX1RFTVBMQVRFDQot
CWZhc3Rlc3QgPSBYT1JfU0VMRUNUX1RFTVBMQVRFKGZhc3Rlc3QpOw0KLSNlbmRpZg0KLQ0KIAlh
Y3RpdmVfdGVtcGxhdGUgPSBmYXN0ZXN0Ow0KLQlwcmludGsoInJhaWQ1OiB1c2luZyBmdW5jdGlv
bjogJXMgKCVkLiUwM2QgTUIvc2VjKVxuIiwNCi0JICAgICAgIGZhc3Rlc3QtPm5hbWUsIGZhc3Rl
c3QtPnNwZWVkIC8gMTAwMCwgZmFzdGVzdC0+c3BlZWQgJSAxMDAwKTsNCi0NCiAJcmV0dXJuIDA7
DQogfQ0KIA0K

--=-c9zElOBgUej8pXwwNZWX--
