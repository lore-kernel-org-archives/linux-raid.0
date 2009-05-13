From: Neil Brown <neilb@suse.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 14:54:45 +1000
Message-ID: <18954.21141.982191.727975@notabene.brown>
References: <4A060CBE.9090308@tmr.com>
	<20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<18954.19719.172893.761454@notabene.brown>
	<37d33d830905122137l18f13c2aoec8e1cf67fdba2c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Wednesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 13, sandeepksinha@gmail.com wrote:
> Hi,
>=20
> On Wed, May 13, 2009 at 10:01 AM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday May 12, lrhorer@satx.rr.com wrote:
> >>
> >> But doesn't creating the array with the drive wipe the contents? =A0=
If so, it
> >> doesn't seem to me this provides much redundancy.
> >
> > No. =A0Creating an array does not wipe the contents.
> > It might cause a resync which will copy contents from one drive to =
the
> > other and I don't promise which one.
> > However if you:
> >
> Now, my question is that what if I create a RAID1 with 100 disks on e=
ach side.
> Do you mean to say that there will be unnecessary resync happening
> there as well, that too for unallocated/written data.

I'm not sure what "100 disks on each side" means.
Do you mean a raid1 across 100 devices?  i.e. 100 copies of each
block?

In any case, md has no concept of unallocated/written data.  Every
block is potentially meaningful and needs to be copied for resync.

I have had thoughts about keeping track of which blocks have been used
so that 'TRIM' can be passed down.  But it is a long way from being a
reality.


>=20
> If thats the case, we surely need to handle these two situations
> differently (1) which neil mentioned (2) the one I mentioned above.
>=20
> Remember I referring to the case of creation.
>=20
> > =A0 mdadm -C /dev/md0 --level 1 -n 2 /dev/foo missing
> > =A0 mdadm /dev/md0 --add /dev/bar
> >
> > then the contents on /dev/foo will not be changed (except for a few=
 K
> > at the end for the metadata) and then all of foo will be copied to
> > bar.
> >
>=20
> Will the create happen at the first place?

I don't understand this question, sorry.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
