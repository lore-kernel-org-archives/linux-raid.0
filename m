From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: status of sas1068 ata-passthrough bug?
Date: Wed, 3 Nov 2010 06:29:14 +0000
Message-ID: <20101103062914.dac21685.ctpm@ist.utl.pt>
References: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
	<20101102220517.41416adb.ctpm@ist.utl.pt>
	<AANLkTi=m0QSBq=W0KoZiSo_5hdbi31z9ipV2z6s5C2=T@mail.gmail.com>
	<20101103032049.3a731d19.ctpm@ist.utl.pt>
	<4CD0D98D.3010503@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD0D98D.3010503@sallaway.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Wed, 03 Nov 2010 13:39:57 +1000 Michael Sallaway <michael@sallaway.c=
om> wrote:
>=20
> On 3/11/2010 1:20 PM, Cl=C3=A1udio Martins wrote:
> > Also, as a last resort, you could try to apply the patch and rebuil=
d
> > using the sources of your favorite distro kernel. The patch is quit=
e
> > simple, but be warned that the MPTSAS module also got some other
> > potentially interesting fixes on the 2.6.36 cycle.
>=20
> Interesting.... where might I find out more info about that? (trying =
to=20
> figure out if I should stay with .35 for now....)
>=20

 Hi,

 What I do is follow Linus' git repository history periodically. I did
a "git clone" of his repo and now do a "git pull" from time to time.

 If you don't have done it already, taking a little time to get to know
the git basic commands is really useful for this kind of stuff. You
don't even need to know all the details of commiting, etc, but just
knowing how to use git-log and git-diff is already useful.

 For example, you would do

 git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
-2.6.git
 cd linux-2.6
 git log --pretty=3Doneline drivers/message/fusion/

 Would give you commits related to mpt and mptsas drivers, while
ignoring unrelated commits. It is also easy to find out whether a given
release has a specific commit or not and find commits by a specific
author and much, much more.

 The commit messages also tend to explain quite well the issues fixed,
so it is usually enough to figure if a given commit is interesting or
not.

 git-diff will also generate a patch which is often good enough to
apply to an older kernel, provided the piece of code hasn't changed a
lot.

 Hope this helps.

Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
