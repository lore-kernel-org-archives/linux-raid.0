From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Preventing a RAID device from starting until all disks are ready
Date: Fri, 15 Oct 2010 01:19:12 -0700 (PDT)
Message-ID: <795353.84173.qm@web51306.mail.re2.yahoo.com>
References: <20101015125448.2c0f7592@notabene>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101015125448.2c0f7592@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>, Neil Brown <neilb@suse.de>
Cc: Andrew Klaassen <clawsoon@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Hi Andrew,
> >=20
> > Andrew Klaassen wrote:
> > > During boot, mdadm starts the array before one of
> the two fibre-channel cards has started its disk
> detection.=A0 The array comes up, but with only 28 of 56
> drives, and I have to manually re-add the drives and cross
> my fingers that nothing will go wrong during the 10-hour
> rebuild.
> >=20
> > Have you considered enabling a write-intent bitmap on
> your array? This=20
> > way, at least your rebuild will take seconds instead
> of 10 hours. Write=20
> > intent bitmap support for RAID10 was introduced in
> 2005, and hopefully=20
> > CentOS 5.2 supports it.
> >=20
> > > Is there any way to tell mdadm to wait longer, or
> to not attempt to start the array if not all devices are
> present, or... (any other solution you can think of)?
> >=20
> > We have iscsi targets for drives in our array, and we
> make sure that=20
> > we've logged into all 30 of our drives before we
> continue to enable=20
> > mdadm (we literally count the number of iscsi sessions
> open). You can=20
> > try counting the number of block devices present (in
> /dev/block) that=20
> > match a certain pattern, or perhaps your fiber channel
> driver offers an=20
> > even more convenient facility in /dev.
> >=20
> > However, it would be great if there really was a way
> to tell mdadm to=20
> > wait until the devices are ready. I'm not aware of one
> though.
> >=20
>=20
> Time to go back and read the mdadm man page.=A0 From top
> to bottom.=A0 Twice.
>=20
> I suspect that --no-degraded is the flag you want.\
>=20
> It was introduced in mdadm 2.5
>=20
> There are three scenarios that could be relevant.
>=20
> 1/ If an array is being assembled explicitly, e.g.
> =A0=A0=A0mdadm --assemble /dev/mdX .....
>  then mdadm will refuse to assemble the array if any
> expected devices are
>  missing.=A0 You need to add "--run" to get it to start
> a partial array.
>=20
> 2/ If an array is being assembled using auto-assembly,
> e.g.
> =A0=A0=A0mdadm --assemble --scan
>  then mdadm will start partial arrays if it cannot find the
> missing parts
>  anyway.=A0 You can tell it not to with
> --no-degraded.=A0 This flag is actually a
>  misnomer.=A0 It may well assemble a degraded array, but
> only if the array was
>  degraded the last time it was active.


This '--no-degraded' option sounds cool. Can you tell it to apply that =
logic on some arrays but not others? Like I have an OS drive that can h=
appily come up as degraded if need be. But I also have a 7 drive data a=
rray that something the cables come adrift on when i am replacing/addin=
g a drive and i'd rather it just not assemble.. so I can go back and ch=
eck.

(sorry to steal the thread; kinda)


>=20
> 3/ If an array is being assembled used a sequence of
> --incremental commands,
> e.g.
> =A0=A0=A0mdadm --incremental /dev/first
> =A0=A0=A0mdadm --incremental /dev/second
> =A0 etc
>=20
>  then mdadm won't assemble the array until all expected
> devices have been
>  found.=A0 Using "--run" will override this so the array
> is assembled as soon
>  as enough devices are present.=A0 Once all possible
> devices have been
>  presented to mdadm it "mdadm -incremental device" you can
> tell mdadm to
>  start any arrays that haven't been started yet with
> =A0=A0=A0mdadm --incremental --run
>=20
> Hope that clears it up.
>=20
> NeilBrown
>=20



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
