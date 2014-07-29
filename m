From: "Matthias Appel" <appel.matthias@gmail.com>
Subject: AW: Crash during recover
Date: Tue, 29 Jul 2014 14:45:56 +0200
Message-ID: <027901cfab2b$0b7a1f90$226e5eb0$@gmail.com>
References: <026c01cfab18$2f479960$8dd6cc20$@gmail.com> <20140729204806.48632819@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140729204806.48632819@notabene.brown>
Content-Language: de
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Urspr=FCngliche Nachricht-----
> Von: NeilBrown [mailto:neilb@suse.de]
> Gesendet: Dienstag, 29. Juli 2014 12:48
> An: Matthias Appel
> Cc: linux-raid@vger.kernel.org
> Betreff: Re: Crash during recover
>=20
> On Tue, 29 Jul 2014 12:30:53 +0200 "Matthias Appel"
> <appel.matthias@gmail.com> wrote:
>=20
> > Hi all,
> >
> > I have a problem with my 4 disk software raid 5.
> > I had a defective disk which I identified and changed and the rebui=
ld
> > started.
[SNIP]

>=20
> Looks like it should start.  What version of mdadm and kernel do you =
have?
> What does:
>=20
>    mdadm -V
>    uname -a
>    mdadm -A /dev/md0 --force -vvv /dev/sd[abe]

Thanks for the hint!
Apparantly I run into some kind of bug (box war running some 13ish Ubun=
tu
AFAIR)!
I booted a up-to-date rescue cd and installed mdadm v3.2.5 and the RAID
started without any hassle!

So, thanks Neil and sorry for the noise on the list..could have tried t=
he
recue cd prior mailing=20
=20
BR,

Matthias




--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
