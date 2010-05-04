From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: Compatible Hardware Controllers (Smartctl, 8 port, SFF-8087)
Date: Tue, 4 May 2010 23:23:12 +0100
Message-ID: <20100504232312.52ae8095.ctpm@ist.utl.pt>
References: <g2mbfcaab951005041145y88e4b350le3e6e2a691160231@mail.gmail.com>
	<z2yc268e4661005041209v95f82e8eo3b59cee8c5b43687@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2yc268e4661005041209v95f82e8eo3b59cee8c5b43687@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Andrew Dunn <andrew.g.dunn.dod@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 4 May 2010 12:09:41 -0700 Drew <drew.kay@gmail.com> wrote:
> > The problem with this controller is that if you try to use smartctl=
 or
> > smartd to monitor your drives, the controller will become unrespons=
ive
> > and offline an arbitrary amount of drives. This causes a huge probl=
em
> > in raid because then the drives get marked as failed and I have to
> > force add them back into the array.
>=20
> This is a known issue with the 1068 series which AFAIK there are some
> patches floating around that resolve this issue. Refer to
> https://bugzilla.kernel.org/show_bug.cgi?id=3D14831 for particulars.
>=20

 Hi,

 Please take a look at

 https://bugzilla.kernel.org/show_bug.cgi?id=3D13594

 As it seems to refer to the same issue.

 A patch is referred on the bottom of the bug page, but I haven't tried
it yet.


On Tue, 4 May 2010 14:45:29 -0400 Andrew Dunn <andrew.g.dunn.dod@gmail.=
com> wrote:
> My solution is basically to move from raid5 to raid6 so that I can
> afford a single drive failure, because I am not preempting a drive
> malfunction.

 Do note that this probably won't do you any good on the long run. I
have this issue and I've seen it kick out several drives in a row, so
you can end up with a dead array even it it's raid6.

 Please let me know if you have any luck with any of the pacthes, and
I'll do so also.

 Best regards.

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
