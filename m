From: tomas.hodek@volny.cz
Subject: raid1 read balance with write mostly
Date: Sat, 02 Feb 2013 18:38:49 +0100 (CET)
Message-ID: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_b068263a2d9324714003e0ea4a8dcbc0"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: tomas.hodek@volny.cz
List-Id: linux-raid.ids

--=_b068263a2d9324714003e0ea4a8dcbc0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I have started to test md raid1 with one ssd and one hdd devices on 3.7.1 kernel (it has trim/discard on raid1). This raid has enabled write behind option and HDD device has enabled write mostly option.
Original idea of write mostly option was "Read requests will only be sent if there is no other option."

My first simple test workload was a building latest stable kernel (3.7.1) using 16 threads.
But i saw some reading from hdd irrespective of a write workload, I saw also more then 1000ms read await while ssd had await about 1ms.  (I only used iostat -x.)

I wanted to know why. I searched in source codes and i found  read_balance function in raid1.c.

If I read well this code and understand it - it do:

If a device has "write mostly" option and if we still have not selected device for reading (and if is_badblock function is ended with true), code select this device directly. This direct selection may be a mistake because overwrite this direct selection is possible only in special cases - if other possible device (without write mostly option) is idle or a request is a part of sequential reads. Standard way read_balance function is searching the nearest and/or the least used device. Such device is using only if we have not a directly selected device (also from write mosty code path).


I thing all code sequence 

best_disk = disk; 
continue;

in main for loop is not best way and that setting 

best_padding_disk  = disk;
best_dist_disk = disk;

is better because it give chance find better alternative. In other words - change direct selection to worst possible alternative. 
But i am not sure in all cases.


I  made 2 version of a small patch to do it which change direct selection to setting write mostly device only as most distant and most pending possible device. Safe version is safe and reliable for future changes, now version is minimal for current code (up to 3.7.5). 

This patch work well for me. I can mark ssd as fail, remove from and add in raid under workload without any trouble or additional kernel log items.

I attach my patches to email.

Best regards
Tomas Hodek 


--=_b068263a2d9324714003e0ea4a8dcbc0
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="raid1-balance-write-mostly_safe.patch"

ZGlmZiAtdXIgbGludXgtMy43LjEtb2xkL2RyaXZlcnMvbWQvcmFpZDEuYyBs
aW51eC0zLjcuMS1uZXcvZHJpdmVycy9tZC9yYWlkMS5jCi0tLSBsaW51eC0z
LjcuMS1vbGQvZHJpdmVycy9tZC9yYWlkMS5jCTIwMTItMTItMTcgMjA6MTQ6
NTQuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0zLjcuMS1uZXcvZHJpdmVy
cy9tZC9yYWlkMS5jCTIwMTMtMDEtMDkgMjA6NTc6NDcuOTI0NjEwNTAxICsw
MTAwCkBAIC01NDgsNyArNTQ4LDcgQEAKIAkJaWYgKHRlc3RfYml0KFdyaXRl
TW9zdGx5LCAmcmRldi0+ZmxhZ3MpKSB7CiAJCQkvKiBEb24ndCBiYWxhbmNl
IGFtb25nIHdyaXRlLW1vc3RseSwganVzdAogCQkJICogdXNlIHRoZSBmaXJz
dCBhcyBhIGxhc3QgcmVzb3J0ICovCi0JCQlpZiAoYmVzdF9kaXNrIDwgMCkg
eworCQkJaWYgKGJlc3RfZGlzdF9kaXNrIDwgMCB8fCBiZXN0X3BlbmRpbmdf
ZGlzayA8IDApIHsKIAkJCQlpZiAoaXNfYmFkYmxvY2socmRldiwgdGhpc19z
ZWN0b3IsIHNlY3RvcnMsCiAJCQkJCQkmZmlyc3RfYmFkLCAmYmFkX3NlY3Rv
cnMpKSB7CiAJCQkJCWlmIChmaXJzdF9iYWQgPCB0aGlzX3NlY3RvcikKQEAg
LTU1Nyw3ICs1NTcsMTAgQEAKIAkJCQkJYmVzdF9nb29kX3NlY3RvcnMgPSBm
aXJzdF9iYWQgLSB0aGlzX3NlY3RvcjsKIAkJCQl9IGVsc2UKIAkJCQkJYmVz
dF9nb29kX3NlY3RvcnMgPSBzZWN0b3JzOwotCQkJCWJlc3RfZGlzayA9IGRp
c2s7CisJCQkJaWYgKGJlc3RfZGlzdF9kaXNrIDwgMCkKKwkJCQkJYmVzdF9k
aXN0X2Rpc2sgPSBkaXNrOworCQkJCWlmIChiZXN0X3BlbmRpbmdfZGlzayA8
IDApCisJCQkJCWJlc3RfcGVuZGluZ19kaXNrID0gZGlzazsKIAkJCX0KIAkJ
CWNvbnRpbnVlOwogCQl9Cg==

--=_b068263a2d9324714003e0ea4a8dcbc0
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="raid1-balance-write-mostly_now.patch"

ZGlmZiAtdXIgbGludXgtMy43LjEtb2xkL2RyaXZlcnMvbWQvcmFpZDEuYyBs
aW51eC0zLjcuMS1uZXcvZHJpdmVycy9tZC9yYWlkMS5jCi0tLSBsaW51eC0z
LjcuMS1vbGQvZHJpdmVycy9tZC9yYWlkMS5jCTIwMTItMTItMTcgMjA6MTQ6
NTQuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0zLjcuMS1uZXcvZHJpdmVy
cy9tZC9yYWlkMS5jCTIwMTMtMDEtMDkgMjA6NTc6NDcuOTI0NjEwNTAxICsw
MTAwCkBAIC01NDgsNyArNTQ4LDcgQEAKIAkJaWYgKHRlc3RfYml0KFdyaXRl
TW9zdGx5LCAmcmRldi0+ZmxhZ3MpKSB7CiAJCQkvKiBEb24ndCBiYWxhbmNl
IGFtb25nIHdyaXRlLW1vc3RseSwganVzdAogCQkJICogdXNlIHRoZSBmaXJz
dCBhcyBhIGxhc3QgcmVzb3J0ICovCi0JCQlpZiAoYmVzdF9kaXNrIDwgMCkg
eworCQkJaWYgKGJlc3RfZGlzdF9kaXNrIDwgMCkgewogCQkJCWlmIChpc19i
YWRibG9jayhyZGV2LCB0aGlzX3NlY3Rvciwgc2VjdG9ycywKIAkJCQkJCSZm
aXJzdF9iYWQsICZiYWRfc2VjdG9ycykpIHsKIAkJCQkJaWYgKGZpcnN0X2Jh
ZCA8IHRoaXNfc2VjdG9yKQpAQCAtNTU3LDcgKzU1Nyw4IEBACiAJCQkJCWJl
c3RfZ29vZF9zZWN0b3JzID0gZmlyc3RfYmFkIC0gdGhpc19zZWN0b3I7CiAJ
CQkJfSBlbHNlCiAJCQkJCWJlc3RfZ29vZF9zZWN0b3JzID0gc2VjdG9yczsK
LQkJCQliZXN0X2Rpc2sgPSBkaXNrOworCQkJCWJlc3RfZGlzdF9kaXNrID0g
ZGlzazsKKwkJCQliZXN0X3BlbmRpbmdfZGlzayA9IGRpc2s7CiAJCQl9CiAJ
CQljb250aW51ZTsKIAkJfQo=

--=_b068263a2d9324714003e0ea4a8dcbc0--
