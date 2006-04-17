From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Tue, 18 Apr 2006 01:28:28 +0200
Message-ID: <62b0912f0604171628q1b62b37fre1e707ed201b45ac@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
	 <62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
	 <17474.59005.812914.343869@cse.unsw.edu.au>
	 <62b0912f0604161810m71cf0086h47a05699b02bc43e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10189_15929458.1145316508359"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604161810m71cf0086h47a05699b02bc43e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_10189_15929458.1145316508359
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Molle Bestefich wrote:
> Neil Brown wrote:
> > > How do I force MD to raise the event counter on sdb1 and accept it
> > > into the array as-is, so I can avoid bad-block induced data
> > > corruption?
> >
> > For that, you have to recreate the array.
>
> Scary.  And hairy.
> How much do I have to bribe you to make this work:
>
> # mdadm --assemble /dev/md1 --force  /dev/sd{a,b,c,d,e,f}1
>
> Not now, that is, but for the sake of future generations? :)

I crossed my fingers and dived into the code.
The mdadm code was super well written - Thanks, Neil :-) - so
conjuring up a patch took less than 5 minutes.

Patch attached - does it look acceptable for inclusion in mainline?

With the patch, I can do this:
# mdadm --assemble /dev/md1 --force /dev/sd{a,b,c,d,e,f}1
mdadm: forcing event count in /dev/sdb1(1) from 160264 upto 163368
mdadm: clearing FAULTY flag for device 1 in /dev/md1 for /dev/sdb1
mdadm: /dev/md1 has been started with 6 drives.

And have the array started with all 6 devices (as I've asked it for).

------=_Part_10189_15929458.1145316508359
Content-Type: text/x-diff; name="mdadm_when_assembly_forced_and_devices_specified_use_those.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mdadm_when_assembly_forced_and_devices_specified_use_those.patch"
X-Attachment-Id: file0

LS0tIEFzc2VtYmxlLmMub2sJMjAwNi0wNC0xOCAwMjo0NzoxMS4wMDAwMDAwMDAgKzAyMDAKKysr
IEFzc2VtYmxlLmMJMjAwNi0wNC0xOCAwMToxODozOC4wMDAwMDAwMDAgKzAyMDAKQEAgLTExOSw2
ICsxMTksNyBAQAogCXN0cnVjdCBtZGluZm8gaW5mbzsKIAljaGFyICphdmFpbDsKIAlpbnQgbmV4
dHNwYXJlID0gMDsKKwlpbnQgZGV2c19vbl9jbWRsaW5lID0gZGV2bGlzdCE9TlVMTDsKIAkKIAl2
ZXJzID0gbWRfZ2V0X3ZlcnNpb24obWRmZCk7CiAJaWYgKHZlcnMgPD0gMCkgewpAQCAtNDA3LDkg
KzQwOCwxMCBAQAogCQkJCXNwYXJlY250Kys7CiAJCX0KIAl9Ci0Jd2hpbGUgKGZvcmNlICYmICFl
bm91Z2goaW5mby5hcnJheS5sZXZlbCwgaW5mby5hcnJheS5yYWlkX2Rpc2tzLAorCXdoaWxlIChm
b3JjZSAmJiAoKCFlbm91Z2goaW5mby5hcnJheS5sZXZlbCwgaW5mby5hcnJheS5yYWlkX2Rpc2tz
LAogCQkJCWluZm8uYXJyYXkubGF5b3V0LAotCQkJCWF2YWlsLCBva2NudCkpIHsKKwkJCQlhdmFp
bCwgb2tjbnQpKSB8fAorCQkJCShkZXZzX29uX2NtZGxpbmUgJiYgKG51bV9kZXZzID4gb2tjbnQp
KSkpIHsKIAkJLyogQ2hvb3NlIHRoZSBuZXdlc3QgYmVzdCBkcml2ZSB3aGljaCBpcwogCQkgKiBu
b3QgdXAtdG8tZGF0ZSwgdXBkYXRlIHRoZSBzdXBlcmJsb2NrCiAJCSAqIGFuZCBhZGQgaXQuCg==

------=_Part_10189_15929458.1145316508359--
