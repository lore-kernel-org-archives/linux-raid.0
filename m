From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work correctly
 in all cases
Date: Thu, 24 Feb 2011 16:04:30 -0500
Message-ID: <AANLkTin14zpCfb9YkN-hvW35JhXo1UM6jNU+jTHJmVB6@mail.gmail.com>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
	<20110121072515.07dc2b74@notabene.brown>
	<AANLkTi=NqHV9p0rc4VBBNAzxwjvfA0DpKgkxQpsX9gsT@mail.gmail.com>
	<AANLkTimS00pyoN2f4E-2ZbSLq8-Xar3oj9DZ2sEfXzgs@mail.gmail.com>
	<20110202113215.3e106ccb@notabene.brown>
	<AANLkTin_Xuo5hwPXr5bnYZJX5zjZheFaeYB6cDvOW-Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec53f943d4a2719049d0d8f8b
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_Xuo5hwPXr5bnYZJX5zjZheFaeYB6cDvOW-Qg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--bcaec53f943d4a2719049d0d8f8b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

OK, so I finally got back to this. Just FYI, a slight adjustment to
the patch was needed (bitmap_info now has the max_write_behind field).
It's attached. You need both the barrier-retry-fix-2 patch that I
posted a while back and this one.

Thanks,
Paul



On Tue, Feb 1, 2011 at 8:04 PM, Paul Clements <paul.clements@us.sios.com> w=
rote:
> On Tue, Feb 1, 2011 at 7:32 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 1 Feb 2011 15:45:16 -0500 Paul Clements <paul.clements@us.sios.c=
om>
>> wrote:
>> Disabling behind-writes for all barrier requests would be quite easy, bu=
t it
>> might negate a lot of the value of behind writes
>
> Agreed...
>
>> I think the best option is to reject barrier writes if there are any
>> behind-write devices. =A0That would be reasonably safe and reasonably
>> consistent.
>
> Yeah, I was leaning toward this.
>
>> So maybe something like this??
>
> Yes, I think that would work.
>
> Thanks,
> Paul
>

--bcaec53f943d4a2719049d0d8f8b
Content-Type: text/x-patch; charset=US-ASCII;
	name="md-disable-barriers-with-write-behind.diff"
Content-Disposition: attachment;
	filename="md-disable-barriers-with-write-behind.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkk5uoi30

LS0tIC4vZHJpdmVycy9tZC9iaXRtYXAuYy5QUklTVElORQkyMDExLTAyLTIzIDE3OjQwOjI2LjYz
MzI3MDgxNCAtMDUwMAorKysgLi9kcml2ZXJzL21kL2JpdG1hcC5jCTIwMTEtMDItMjMgMTQ6NDc6
MzguNjUyNDM0NzQ1IC0wNTAwCkBAIC0xMjk4LDggKzEyOTgsNyBAQCBpbnQgYml0bWFwX3N0YXJ0
d3JpdGUoc3RydWN0IGJpdG1hcCAqYml0CiAJCWlmIChidyA+IGJpdG1hcC0+YmVoaW5kX3dyaXRl
c191c2VkKQogCQkJYml0bWFwLT5iZWhpbmRfd3JpdGVzX3VzZWQgPSBidzsKIAotCQlQUklOVEso
S0VSTl9ERUJVRyAiaW5jIHdyaXRlLWJlaGluZCBjb3VudCAlZC8lZFxuIiwKLQkJICAgICAgIGJ3
LCBiaXRtYXAtPm1heF93cml0ZV9iZWhpbmQpOworCQlQUklOVEsoS0VSTl9ERUJVRyAiaW5jIHdy
aXRlLWJlaGluZCBjb3VudCAlZFxuIiwgYncpOwogCX0KIAogCXdoaWxlIChzZWN0b3JzKSB7CkBA
IC0xMzU3LDggKzEzNTYsOCBAQCB2b2lkIGJpdG1hcF9lbmR3cml0ZShzdHJ1Y3QgYml0bWFwICpi
aXRtCiAJaWYgKCFiaXRtYXApIHJldHVybjsKIAlpZiAoYmVoaW5kKSB7CiAJCWF0b21pY19kZWMo
JmJpdG1hcC0+YmVoaW5kX3dyaXRlcyk7Ci0JCVBSSU5USyhLRVJOX0RFQlVHICJkZWMgd3JpdGUt
YmVoaW5kIGNvdW50ICVkLyVkXG4iLAotCQkgIGF0b21pY19yZWFkKCZiaXRtYXAtPmJlaGluZF93
cml0ZXMpLCBiaXRtYXAtPm1heF93cml0ZV9iZWhpbmQpOworCQlQUklOVEsoS0VSTl9ERUJVRyAi
ZGVjIHdyaXRlLWJlaGluZCBjb3VudCAlZFxuIiwKKwkJICBhdG9taWNfcmVhZCgmYml0bWFwLT5i
ZWhpbmRfd3JpdGVzKSk7CiAJfQogCWlmIChiaXRtYXAtPm1kZGV2LT5kZWdyYWRlZCkKIAkJLyog
TmV2ZXIgY2xlYXIgYml0cyBvciB1cGRhdGUgZXZlbnRzX2NsZWFyZWQgd2hlbiBkZWdyYWRlZCAq
LwpAQCAtMTcxMyw2ICsxNzEyLDEwIEBAIGludCBiaXRtYXBfY3JlYXRlKG1kZGV2X3QgKm1kZGV2
KQogCWlmIChlcnIpCiAJCWdvdG8gZXJyb3I7CiAKKwkvKiB3cml0ZSBiZWhpbmQgYW5kIGJhcnJp
ZXIgd3JpdGUgcmV0cmllcyBhcmUgbm90IGNvbXBhdGlibGUgKi8KKwlpZiAobWRkZXYtPmJpdG1h
cF9pbmZvLm1heF93cml0ZV9iZWhpbmQpCisJCW1kZGV2LT5iYXJyaWVyc193b3JrID0gMDsKKwog
CWJpdG1hcC0+ZGFlbW9uX2xhc3RydW4gPSBqaWZmaWVzOwogCWJpdG1hcC0+Y2h1bmtzaGlmdCA9
IGZmeih+bWRkZXYtPmJpdG1hcF9pbmZvLmNodW5rc2l6ZSk7CiAK
--bcaec53f943d4a2719049d0d8f8b--
