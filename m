From: Danilo Godec <danci@agenda.si>
Subject: Re: mdrecoveryd oops
Date: Thu, 30 May 2002 11:52:25 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205301148420.13515-101000@duplo.agenda.si>
References: <3CF5E020.70200@ynet.sk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-154941680-330858946-1022752345=:13515"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3CF5E020.70200@ynet.sk>
To: VanTo <vanto@ynet.sk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---154941680-330858946-1022752345=:13515
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 30 May 2002, VanTo wrote:

> I also wanted to ask if it is supported to use md array during recovery?
> (with some journaling fs on it). When a system fails I have to wait for
> about 1 hour while recovery finishes before i mount fs on md, or else it
> crashes. I tried many kernel versions from 2.4.16 to 2.4.19-pre8, with
> the same result.

It *should* work. Are you using this on a SMP machine? There are some race
situations causing crashes, but it should work with an UP machine.

Here is a patch produced by gody@agenda.si that should help in SMP
machine. It not pretty and it's not '100% right', but it seems to work.

   D.


---154941680-330858946-1022752345=:13515
Content-Type: APPLICATION/x-patch; name="md.race.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.30.0205301152250.13515@duplo.agenda.si>
Content-Description: 
Content-Disposition: attachment; filename="md.race.patch"

ZGlmZiAtdU5yIGxpbnV4Lm9yaWcvZHJpdmVycy9tZC9tZC5jIGxpbnV4L2Ry
aXZlcnMvbWQvbWQuYwotLS0gbGludXgub3JpZy9kcml2ZXJzL21kL21kLmMJ
RnJpIERlYyAyMSAxODo0MTo1NCAyMDAxCisrKyBsaW51eC9kcml2ZXJzL21k
L21kLmMJTW9uIE1hciAxMSAxMzoyOTo1MCAyMDAyCkBAIC00NjgsNiArNDY4
LDE5IEBACiAJfQogfQogCitzdGF0aWMgaW5saW5lIGludCBtYXJrX3JkZXZf
ZmF1bHR5IChtZGtfcmRldl90ICogcmRldikKK3sKKyAgICAgICBpZiAoIXJk
ZXYpIHsKKyAgICAgICAgICAgICAgIE1EX0JVRygpOworICAgICAgICAgICAg
ICAgcmV0dXJuIDA7CisgICAgICAgfQorICAgICAgIGlmIChyZGV2LT5mYXVs
dHkpCisgICAgICAgICAgICAgICByZXR1cm4gMDsKKyAgICAgICBmcmVlX2Rp
c2tfc2IocmRldik7CisgICAgICAgcmRldi0+ZmF1bHR5ID0gMTsKKyAgICAg
ICByZXR1cm4gMTsKK30KKwogc3RhdGljIGludCByZWFkX2Rpc2tfc2IobWRr
X3JkZXZfdCAqIHJkZXYpCiB7CiAJaW50IHJldCA9IC1FSU5WQUw7CkBAIC0z
MDQ4LDEwICszMDYxLDE0IEBACiAJcnJkZXYgPSBmaW5kX3JkZXYobWRkZXYs
IHJkZXYpOwogCWlmICghcnJkZXYgfHwgcnJkZXYtPmZhdWx0eSkKIAkJcmV0
dXJuIDA7CisJaWYgKCFtYXJrX3JkZXZfZmF1bHR5KHJyZGV2KSkKKwkJcmV0
dXJuIDA7CiAJaWYgKCFtZGRldi0+cGVycy0+ZXJyb3JfaGFuZGxlcgogCQkJ
fHwgbWRkZXYtPnBlcnMtPmVycm9yX2hhbmRsZXIobWRkZXYscmRldikgPD0g
MCkgeworLyoKIAkJZnJlZV9kaXNrX3NiKHJyZGV2KTsKIAkJcnJkZXYtPmZh
dWx0eSA9IDE7CisqLwogCX0gZWxzZQogCQlyZXR1cm4gMTsKIAkvKgo=
---154941680-330858946-1022752345=:13515--
