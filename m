From: Neil Brown <neilb@suse.de>
Subject: Re: Possibility for a parallel relaxed RAID?
Date: Fri, 19 Mar 2010 12:54:07 +1100
Message-ID: <20100319125407.393ce922@notabene.brown>
References: <4BA27898.4010907@panix.com>
	<20100319085414.6cdddd29@notabene.brown>
	<7db987b31003181600v30e7efeboaf7c8d0d40dde429@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003181600v30e7efeboaf7c8d0d40dde429@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: Berkey B Walker <berk@panix.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Mar 2010 17:00:04 -0600
Randy Terbush <randy@terbush.org> wrote:

> Neil,
>=20
> How does md make the decision to drop a drive from the array? Is it a
> fail message back from the ATA layer? Quickly getting over my head
> here, but I would like to think there are different types of failures
> and a failure to complete error correction on the drive should not be
> a fatal error to md.

md gets an error from the block layer, which gets it from the ata layer=
=2E
There is a facility to transfer back a status describing the type of er=
ror
however
  - I don't believe it is used consistently, nor is there a list of=20
    usable errors
  - md currently makes a minimal assumption about an error, so the
    only use in md for this would be to be less gentle, not more gentle=
=2E

If a drive has "a failure to complete error correction", then I suspect=
 they
presents as a read error.  md will try to get the data from elsewhere a=
nd
re-write it.  If that fails it becomes a write error, and a device that
cannot be written to is useless, so md fails it.

There are plans to add support for a bad-block-list to md so that when
we get a write failure or a read failure on a degraded array we can mar=
k just
that block as faulty.  However these plans are currently languishing du=
e to
lack of time.

>=20
> This request is the same as the post I have made earlier this week
> regarding "RAID class" drives which I would love to get your response
> to.

I think the only part of the which is relevant to me is:

>  However, I do not understand why the RAID system
> cannot detect the type of drive it is dealing with and either disable
> the behavior on the drive or allow more time for the drive to respond
> before kicking it out of the array.

It doesn't disable anything because no-one has written code to do so.
I know virtually nothing about ata controller and protocols and such so=
 I am
not really the person to do it.
This would either be something that mdadm did when it added a drive to =
an
array, or something that the kernel did when md asked it some how.
I suggest you talk to someone who knows about sata - or submit a patch
yourself.

The "allow more time for the drive to respond" is not an issue for md. =
 It
has no timeouts.   It might be an issue for the sata controller.

NeilBrown


>=20
> Tks
>=20
> On Thu, Mar 18, 2010 at 3:54 PM, Neil Brown <neilb@suse.de> wrote:
> > On Thu, 18 Mar 2010 15:01:44 -0400
> > Berkey B Walker <berk@panix.com> wrote:
> >
> >> There maybe many folks out there who want to use RAID on their per=
sonal,
> >> non-production systems. =C2=A0Assuming access and thru-put values =
are not
> >> critical a problem might be "You can't use Desktop drives for RAID=
".
> >> Which, I think, most of us know is not really true, but - - If the
> >> timing issues were to be relaxed, allowing the drive to fix itself=
,
> >> before being kicked by the md process, might not the average Joe b=
e
> >> better served? =C2=A0There is a big difference between going a mil=
e and
> >> buying a commodity drive, and being "up" in an hour vs. finding a
> >> working system, going online, paying price+, and getting/paying fa=
st
> >> shipping. Which might resolve the issue in days instead of hours.
> >>
> >> Any possibility of a parallel, less critical to drive response, re=
lease
> >> of md? =C2=A0Or a patch to allow same?
> >
> > This is not a function of 'md'. =C2=A0md has no timeouts for drives=
 responding.
> > It just submits a request and waits for a success/fail reply.
> >
> > It may be a function of the lower level SATA/SCSI/FC/whatever drive=
r. =C2=A0You
> > would do better to ask the developers of those drivers, maybe start=
 with the
> > maintainer of libata.
> >
> > NeilBrown
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
