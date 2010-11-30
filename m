From: Neil Brown <neilb@suse.de>
Subject: Re: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Tue, 30 Nov 2010 11:42:57 +1100
Message-ID: <20101130114257.01134d62@notabene.brown>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com>
	<AANLkTinUmZoqSWNZ7NK+tg5DTpc5JFbbPPZV6YONq+ox@mail.gmail.com>
	<20101129152916.GB13310@www2.open-std.org>
	<AANLkTikPbbGbqRgF=ZR+nw-7Lf7_zcwcMtSsXzOowvFu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikPbbGbqRgF=ZR+nw-7Lf7_zcwcMtSsXzOowvFu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Nov 2010 23:00:19 +0700 hansbkk@gmail.com wrote:

> 2010/11/29 Keld J=F8rn Simonsen <keld@keldix.com>:
> >> I can see how RAID6 is simpler than RAID10, but compared to RAID1?
> >
> > Hmm, does not compute by me. RAID1 and RAID10 are the same in compl=
exity,
> > RAID10 is just a modern RAID1, and should actually have been called
> > RAID1.
>=20
> My understanding is that if I use RAID10 on a single pair of disks
> then that is literally the same as RAID1. These to me are very simple
> in that I can take either one of the pair and mount it on any normal
> machine and get at the data without doing anything special.
>=20
> However, if I have my six disks configured as a single RAID10 array, =
I
> believe this is no longer true - the data from (at least the larger
> of) the files has been distributed over all six disks, correct?
>=20
> Now compare putting LVM on top of this array, compared to three RAID1
> pairs on the one hand and a RAID6 array on the other (third) hand :)
>=20
> If I were trying to recover the data using the latest version of a
> LiveCD - say Fedora or Knoppix, which would be easier?
>=20
> I'm not trying to score any points, it's a genuine question.


If you are comparing recovering after some sort of problem with
a RAID10 over 6 devices compared with  LVM over 2 2-device RAID1s, then=
 the
former is certainly easier.  This is simply because there are less laye=
rs of
complexity where something could go wrong.

In both cases, your data will be spread across multiple disks, and any =
one
disk or even any two disks would be of no use to you.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
