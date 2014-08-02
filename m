From: Markus Stockhausen <stockhausen@collogia.de>
Subject: raid5: introduce rmw_level option
Date: Sat, 2 Aug 2014 17:51:36 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863A625@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_12EF8D94C6F8734FB2FF37B9FBEDD1735863A625EXCHANGEcollogi_"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--_002_12EF8D94C6F8734FB2FF37B9FBEDD1735863A625EXCHANGEcollogi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

As this is my first patch to this mailing list, please excuse any formal =
=0A=
wrongdoing. I'm willing to learn and appreciate any feedback. =0A=
=0A=
Depending on the RAID level md currently allows optimized rmw logic for wri=
te=0A=
operations. It is totally missing in RAID6 code but might be included in =
=0A=
the future. To support easier testing of such an implementation this patch =
=0A=
allows manual control of the rmw/rcw descision through the new interface =
=0A=
/sys/block/mdX/md/rmw_level.=0A=
=0A=
The configuration can handle three levels of control.=0A=
=0A=
rmw_level=3D0: rmw is disabled for all RAID levels. This level is enforced =
for =0A=
RAID6 and from now on allowed for RAID4/5. Maybe it can support benchmark =
=0A=
tests of very special configurations. =0A=
=0A=
rmw_level=3D1: Estimate rmw IOs and rcw IOs. Execute rmw only if we will sa=
ve=0A=
IOs. This equals the "old" unpatched behaviour and will be the default for =
=0A=
RAID4/5. =0A=
=0A=
rmw_level=3D2: Execute rmw even if calculated IOs for rmw and rcw are equal=
.=0A=
We might have higher CPU consumption because of calculating the parity twic=
e=0A=
but it can be benefical otherwise. E.g. RAID4 with fast dedicated paritiy =
=0A=
disk/SSD. The option is implemented just to be forward-looking.=0A=
=0A=
If we switch/grow between RAID levels the flag will be automatically adapte=
d =0A=
to the default sane value required for that level. =0A=
=0A=
This patch is based on a helpful discussion about an older RAID6 rmw patch.=
=0A=
See http://marc.info/?l=3Dlinux-raid&m=3D136660454912729&w=3D1=0A=
=0A=
=0A=

--_002_12EF8D94C6F8734FB2FF37B9FBEDD1735863A625EXCHANGEcollogi_
Content-Type: text/plain; name="d.txt"
Content-Description: d.txt
Content-Disposition: attachment; filename="d.txt"; size=3958;
	creation-date="Sat, 02 Aug 2014 17:46:18 GMT";
	modification-date="Sat, 02 Aug 2014 17:46:18 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBrZXJuZWwtb2xkL2RyaXZlcnMvbWQvcmFpZDUuYyBrZXJuZWwtbmV3L2RyaXZl
cnMvbWQvcmFpZDUuYwotLS0ga2VybmVsLW9sZC9kcml2ZXJzL21kL3JhaWQ1LmMJMjAxNC0wNy0y
OCAxNTowODo0Mi4wMDAwMDAwMDAgKzAwMDAKKysrIGtlcm5lbC1uZXcvZHJpdmVycy9tZC9yYWlk
NS5jCTIwMTQtMDgtMDIgMTc6Mzg6NTIuMzIzNDYzNjc4ICswMDAwCkBAIC0zMDYwLDE0ICszMDYw
LDE0IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9zdHJpcGVfZGlydHlpbmcoc3RydWMKIAkgKiB0aGF0
IGluIGNhc2Ugb2YgZHJpdmUgZmFpbHVyZSBvciByZWFkLWVycm9yIGNvcnJlY3Rpb24sIHdlCiAJ
ICogZ2VuZXJhdGUgY29ycmVjdCBkYXRhIGZyb20gdGhlIHBhcml0eS4KIAkgKi8KLQlpZiAoY29u
Zi0+bWF4X2RlZ3JhZGVkID09IDIgfHwKKwlpZiAoY29uZi0+cm13X2xldmVsID09IDAgfHwKIAkg
ICAgKHJlY292ZXJ5X2NwIDwgTWF4U2VjdG9yICYmIHNoLT5zZWN0b3IgPj0gcmVjb3ZlcnlfY3Ap
KSB7CiAJCS8qIENhbGN1bGF0ZSB0aGUgcmVhbCByY3cgbGF0ZXIgLSBmb3Igbm93IG1ha2UgaXQK
IAkJICogbG9vayBsaWtlIHJjdyBpcyBjaGVhcGVyCiAJCSAqLwogCQlyY3cgPSAxOyBybXcgPSAy
OwotCQlwcl9kZWJ1ZygiZm9yY2UgUkNXIG1heF9kZWdyYWRlZD0ldSwgcmVjb3ZlcnlfY3A9JWxs
dSBzaC0+c2VjdG9yPSVsbHVcbiIsCi0JCQkgY29uZi0+bWF4X2RlZ3JhZGVkLCAodW5zaWduZWQg
bG9uZyBsb25nKXJlY292ZXJ5X2NwLAorCQlwcl9kZWJ1ZygiZm9yY2UgUkNXIHJtd19sZXZlbD0l
dSwgcmVjb3ZlcnlfY3A9JWxsdSBzaC0+c2VjdG9yPSVsbHVcbiIsCisJCQkgY29uZi0+cm13X2xl
dmVsLCAodW5zaWduZWQgbG9uZyBsb25nKXJlY292ZXJ5X2NwLAogCQkJICh1bnNpZ25lZCBsb25n
IGxvbmcpc2gtPnNlY3Rvcik7CiAJfSBlbHNlIGZvciAoaSA9IGRpc2tzOyBpLS07ICkgewogCQkv
KiB3b3VsZCBJIGhhdmUgdG8gcmVhZCB0aGlzIGJ1ZmZlciBmb3IgcmVhZF9tb2RpZnlfd3JpdGUg
Ki8KQEAgLTMwOTQsNyArMzA5NCw3IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9zdHJpcGVfZGlydHlp
bmcoc3RydWMKIAlwcl9kZWJ1ZygiZm9yIHNlY3RvciAlbGx1LCBybXc9JWQgcmN3PSVkXG4iLAog
CQkodW5zaWduZWQgbG9uZyBsb25nKXNoLT5zZWN0b3IsIHJtdywgcmN3KTsKIAlzZXRfYml0KFNU
UklQRV9IQU5ETEUsICZzaC0+c3RhdGUpOwotCWlmIChybXcgPCByY3cgJiYgcm13ID4gMCkgewor
CWlmICgocm13IDwgcmN3IHx8IChybXcgPD0gcmN3ICYmIGNvbmYtPnJtd19sZXZlbCA9PSAyKSkg
JiYgcm13ID4gMCkgewogCQkvKiBwcmVmZXIgcmVhZC1tb2RpZnktd3JpdGUsIGJ1dCBuZWVkIHRv
IGdldCBzb21lIGRhdGEgKi8KIAkJaWYgKGNvbmYtPm1kZGV2LT5xdWV1ZSkKIAkJCWJsa19hZGRf
dHJhY2VfbXNnKGNvbmYtPm1kZGV2LT5xdWV1ZSwKQEAgLTMxMjEsNyArMzEyMSw3IEBAIHN0YXRp
YyB2b2lkIGhhbmRsZV9zdHJpcGVfZGlydHlpbmcoc3RydWMKIAkJCX0KIAkJfQogCX0KLQlpZiAo
cmN3IDw9IHJtdyAmJiByY3cgPiAwKSB7CisJaWYgKChyY3cgPCBybXcgfHwgKHJjdyA8PSBybXcg
JiYgY29uZi0+cm13X2xldmVsICE9IDIpKSAmJiByY3cgPiAwKSB7CiAJCS8qIHdhbnQgcmVjb25z
dHJ1Y3Qgd3JpdGUsIGJ1dCBuZWVkIHRvIGdldCBzb21lIGRhdGEgKi8KIAkJaW50IHFyZWFkID0w
OwogCQlyY3cgPSAwOwpAQCAtNTMyMSw2ICs1MzIxLDQ2IEBAIHJhaWQ1X3N0cmlwZWNhY2hlX3Np
emUgPSBfX0FUVFIoc3RyaXBlX2MKIAkJCQlyYWlkNV9zdG9yZV9zdHJpcGVfY2FjaGVfc2l6ZSk7
CiAKIHN0YXRpYyBzc2l6ZV90CityYWlkNV9zaG93X3Jtd19sZXZlbChzdHJ1Y3QgbWRkZXYgICpt
ZGRldiwgY2hhciAqcGFnZSkKK3sKKwlzdHJ1Y3QgcjVjb25mICpjb25mID0gbWRkZXYtPnByaXZh
dGU7CisJaWYgKGNvbmYpCisJCXJldHVybiBzcHJpbnRmKHBhZ2UsICIlZFxuIiwgY29uZi0+cm13
X2xldmVsKTsKKwllbHNlCisJCXJldHVybiAwOworfQorCitzdGF0aWMgc3NpemVfdAorcmFpZDVf
c3RvcmVfcm13X2xldmVsKHN0cnVjdCBtZGRldiAgKm1kZGV2LCBjb25zdCBjaGFyICpwYWdlLCBz
aXplX3QgbGVuKQoreworCXN0cnVjdCByNWNvbmYgKmNvbmYgPSBtZGRldi0+cHJpdmF0ZTsKKwl1
bnNpZ25lZCBsb25nIG5ldzsKKworCWlmICghY29uZikKKwkJcmV0dXJuIC1FTk9ERVY7CisKKwlp
ZiAobGVuID49IFBBR0VfU0laRSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlpZiAoa3N0cnRvdWwo
cGFnZSwgMTAsICZuZXcpKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCWlmIChuZXcgPCAwIHx8IG5l
dyA+IDIpCisJCXJldHVybiAtRUlOVkFMOworCS8qIFJBSUQ2IGRvZXMgbm90IHN1cHBvcnQgcm13
IHlldCAqLworCWlmIChuZXcgPiAwICYmIGNvbmYtPmxldmVsID09IDYpCisJCXJldHVybiAtRUlO
VkFMOworCisJY29uZi0+cm13X2xldmVsID0gbmV3OworCXJldHVybiBsZW47Cit9CisKK3N0YXRp
YyBzdHJ1Y3QgbWRfc3lzZnNfZW50cnkKK3JhaWQ1X3Jtd19sZXZlbCA9IF9fQVRUUihybXdfbGV2
ZWwsIFNfSVJVR08gfCBTX0lXVVNSLAorCQkJIHJhaWQ1X3Nob3dfcm13X2xldmVsLAorCQkJIHJh
aWQ1X3N0b3JlX3Jtd19sZXZlbCk7CisKK3N0YXRpYyBzc2l6ZV90CiByYWlkNV9zaG93X3ByZXJl
YWRfdGhyZXNob2xkKHN0cnVjdCBtZGRldiAqbWRkZXYsIGNoYXIgKnBhZ2UpCiB7CiAJc3RydWN0
IHI1Y29uZiAqY29uZiA9IG1kZGV2LT5wcml2YXRlOwpAQCAtNTQzOSw2ICs1NDc5LDcgQEAgc3Rh
dGljIHN0cnVjdCBhdHRyaWJ1dGUgKnJhaWQ1X2F0dHJzW10gPQogCSZyYWlkNV9zdHJpcGVjYWNo
ZV9hY3RpdmUuYXR0ciwKIAkmcmFpZDVfcHJlcmVhZF9ieXBhc3NfdGhyZXNob2xkLmF0dHIsCiAJ
JnJhaWQ1X2dyb3VwX3RocmVhZF9jbnQuYXR0ciwKKwkmcmFpZDVfcm13X2xldmVsLmF0dHIsCiAJ
TlVMTCwKIH07CiBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCByYWlkNV9hdHRyc19ncm91
cCA9IHsKQEAgLTU3NjIsMTAgKzU4MDMsMTMgQEAgc3RhdGljIHN0cnVjdCByNWNvbmYgKnNldHVw
X2NvbmYoc3RydWN0CiAKIAljb25mLT5jaHVua19zZWN0b3JzID0gbWRkZXYtPm5ld19jaHVua19z
ZWN0b3JzOwogCWNvbmYtPmxldmVsID0gbWRkZXYtPm5ld19sZXZlbDsKLQlpZiAoY29uZi0+bGV2
ZWwgPT0gNikKKwlpZiAoY29uZi0+bGV2ZWwgPT0gNikgewogCQljb25mLT5tYXhfZGVncmFkZWQg
PSAyOwotCWVsc2UKKwkJY29uZi0+cm13X2xldmVsID0gMDsKKwl9IGVsc2UgewogCQljb25mLT5t
YXhfZGVncmFkZWQgPSAxOworCQljb25mLT5ybXdfbGV2ZWwgPSAxOworCX0KIAljb25mLT5hbGdv
cml0aG0gPSBtZGRldi0+bmV3X2xheW91dDsKIAljb25mLT5yZXNoYXBlX3Byb2dyZXNzID0gbWRk
ZXYtPnJlc2hhcGVfcG9zaXRpb247CiAJaWYgKGNvbmYtPnJlc2hhcGVfcHJvZ3Jlc3MgIT0gTWF4
U2VjdG9yKSB7CmRpZmYgLXJ1cE4ga2VybmVsLW9sZC9kcml2ZXJzL21kL3JhaWQ1Lmgga2VybmVs
LW5ldy9kcml2ZXJzL21kL3JhaWQ1LmgKLS0tIGtlcm5lbC1vbGQvZHJpdmVycy9tZC9yYWlkNS5o
CTIwMTQtMDctMjggMTU6MDg6NDIuMDAwMDAwMDAwICswMDAwCisrKyBrZXJuZWwtbmV3L2RyaXZl
cnMvbWQvcmFpZDUuaAkyMDE0LTA4LTAyIDE2OjI4OjA3LjA0NTkxMDczMSArMDAwMApAQCAtMzk2
LDcgKzM5Niw3IEBAIHN0cnVjdCByNWNvbmYgewogCXNwaW5sb2NrX3QJCWhhc2hfbG9ja3NbTlJf
U1RSSVBFX0hBU0hfTE9DS1NdOwogCXN0cnVjdCBtZGRldgkJKm1kZGV2OwogCWludAkJCWNodW5r
X3NlY3RvcnM7Ci0JaW50CQkJbGV2ZWwsIGFsZ29yaXRobTsKKwlpbnQJCQlsZXZlbCwgYWxnb3Jp
dGhtLCBybXdfbGV2ZWw7CiAJaW50CQkJbWF4X2RlZ3JhZGVkOwogCWludAkJCXJhaWRfZGlza3M7
CiAJaW50CQkJbWF4X25yX3N0cmlwZXM7Cg==

--_002_12EF8D94C6F8734FB2FF37B9FBEDD1735863A625EXCHANGEcollogi_
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

--_002_12EF8D94C6F8734FB2FF37B9FBEDD1735863A625EXCHANGEcollogi_--
