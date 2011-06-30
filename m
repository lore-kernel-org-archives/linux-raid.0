From: NeilBrown <neilb@suse.de>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Thu, 30 Jun 2011 10:25:22 +1000
Message-ID: <20110630102522.3dd9579d@notabene.brown>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
	<BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
	<BANLkTin7f-8tLDoZsmyFocb9j1e1wn=4Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTin7f-8tLDoZsmyFocb9j1e1wn=4Dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 08:45:33 -0700 Simon Matthews
<simon.d.matthews@gmail.com> wrote:

> Neil,
>=20
>=20
>=20
> On Tue, Jun 28, 2011 at 10:24 PM, Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
> > Neil,
> >
> >
> >
> > On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> >> =A0mdadm -S /dev/md4
> >> =A0mdadm -A /dev/md4 /dev/sdc1 /dev/sdd1 --verbose
> >
> > That solved it. The array started.
>=20
> Do you have any idea why the array did not start when the system
> booted? I also have an md6 on the same hard drives that was created a=
t
> the same time as md4, but md6 started on the boot.
>=20

Not really ... I would need to see logs to be at all confident.

Based on the very limit info I have my best guess is that something -
probably udev - ran
   mdadm --incremental /dev/sdc1

but didn't run
   mdadm --incremental /dev/sdd1

I cannot imagine why it would do that though.

This would have the effect of leaving sdc1 as a member of md4, but md4 =
still
being inactive.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
