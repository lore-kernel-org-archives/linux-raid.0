From: NeilBrown <neilb@suse.de>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Wed, 29 Jun 2011 16:18:56 +1000
Message-ID: <20110629161856.05e35291@notabene.brown>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
	<BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
	<20110629153753.5279c034@notabene.brown>
	<BANLkTi=GwnMMA2jEZbtrRh3W4Ff-C18teg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=GwnMMA2jEZbtrRh3W4Ff-C18teg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Jun 2011 22:59:43 -0700 Simon Matthews
<simon.d.matthews@gmail.com> wrote:

> Neil,
>=20
>=20
>=20
> On Tue, Jun 28, 2011 at 10:37 PM, NeilBrown <neilb@suse.de> wrote:
> >> On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> >> > =A0mdadm -S /dev/md5
> >> > =A0mdadm -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean
> >>
>=20
> Am I correct in thinking that this should be a quick operation?
>=20

Yes.  Virtually instantaneous.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
