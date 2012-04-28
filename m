From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sun, 29 Apr 2012 07:28:44 +1000
Message-ID: <20120429072844.5e0001b0@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<4F9B14FA.1090001@weboperative.com>
	<20120428080522.637bc564@notabene.brown>
	<4F9B2BE1.5080207@weboperative.com>
	<4F9B3B48.8020900@weboperative.com>
	<4F9B57E9.2060409@weboperative.com>
	<20120428125506.6a2388eb@notabene.brown>
	<4F9B5D24.1050708@weboperative.com>
	<20120428132331.01396da6@notabene.brown>
	<4F9B695D.8030105@weboperative.com>
	<4F9C0B66.90102@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hYoZXEaQmbBihzMl_Fibs.H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9C0B66.90102@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hYoZXEaQmbBihzMl_Fibs.H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Apr 2012 11:23:18 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:

> On 04/27/2012 11:51 PM, likewhoa wrote:
> > On 04/27/2012 11:23 PM, NeilBrown wrote:
> >> On Fri, 27 Apr 2012 22:59:48 -0400 likewhoa <likewhoa@weboperative.com=
> wrote:
> >>
> >>> On 04/27/2012 10:55 PM, NeilBrown wrote:
> >>>> On Fri, 27 Apr 2012 22:37:29 -0400 likewhoa <likewhoa@weboperative.c=
om> wrote:
> >>>>
> >>>>> On 04/27/2012 08:35 PM, likewhoa wrote:
> >>>>>> I am not sure how to proceed now with the output that shows possib=
le
> >>>>>> pairs as it won't allow me to setup all 8 devices on the array but=
 only
> >>>>>> 4. Should I run the array creation with -x4 and set the available =
spare
> >>>>>> devicesor or just create the array as I can remember which was one=
 pair
> >>>>>> from each controller. i.e /dev/sda3 /dev/sde3 ...?
> >>>>>> --
> >>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>> ok I was able to recreate the array with correct order which I took=
 from
> >>>>> my /dev/md0's --details output and was able to decrypt the luks map=
ping
> >>>>> but XFS didn't open and xfs_repair is currently doing the matrix. I=
 will
> >>>>> keep this posted with updates.
> >>>> I hope the order really is correct.... I wouldn't expect xfs to find=
 problems
> >>>> if it was...
> >>>>
> >>>>> Thanks again Neil.
> >>>>> WRT 3.3.3 should I just go back to 3.3.2 which seemed to run fine a=
nd
> >>>>> wait until there is a release of 3.3.3 that has fix?
> >>>> 3.3.4 has the fix and was just released.
> >>>> 3.3.1, 3.3.2 and 3.3.3 all have the bug.  It only triggers on shutdo=
wn and
> >>>> even then only occasionally.
> >>>> So I recommend 3.3.4.
> >>>>
> >>>> NeilBrown
> >>> The reason I believe it was correct was that 'cryptsetup luksOpen
> >>> /dev/md1 md1' worked. I really do hope that it was correct too because
> >>> after opening the luks mapping I assume there is no going back.
> >> Opening the luks mapping could just mean that the first few blocks are
> >> correct.  So the first disk is right but others might not be.
> >>
> >> There is going backup unless something has been written to the array. =
 Once
> >> that happens anything could be corrupted.  So if the xfs check you are=
  doing
> >> is read-only you could still have room to move.
> >>
> >> With a far=3D2 array, each first half of each device is mirrored on th=
e second
> >> half.  So you can probably recover the ordering by finding which pairs=
 match.
> >>
> >> The "Used Dev Size" is 902992896 sectors.  Half of that is 451496448
> >> or 231166181376 bytes.
> >>
> >> So to check if two devices are adjacent in the mapping you can try:
> >>
> >>  cmp --ignore-initial=3D0:231166181376 --bytes=3D231166181376 first-de=
v second-dev
> >>
> >> You could possibly use a smaller --bytes=3D number, at least on the fi=
rst
> >> attempt.
> >> You a similar 'for' loop to before an use this command and it might te=
ll you
> >> which pairs of devices are consecutive.  From that you should be able =
to get
> >> the full order.
> >>
> >> NeilBrown
> >>
> > I don't see why xfs_repair would write data unless it actually finds the
> > superblock but I am not sure so I will take my chances since it's still
> > searching for the secondary superblock now.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> After running the for loop all night which produced this output.
>=20
> /dev/sda3 /dev/sdb3 differ: byte 1, line 1
> /dev/sda3 /dev/sdc3 differ: byte 262145, line 2
> /dev/sda3 /dev/sdd3 differ: byte 1, line 1
> /dev/sda3 /dev/sde3 differ: byte 1, line 1
> /dev/sda3 and /dev/sdf3 seem to match
> /dev/sda3 /dev/sdg3 differ: byte 262145, line 2
> /dev/sda3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdb3 /dev/sda3 differ: byte 1, line 1
> /dev/sdb3 /dev/sdc3 differ: byte 1, line 1
> /dev/sdb3 /dev/sdd3 differ: byte 1, line 1
> /dev/sdb3 and /dev/sde3 seem to match
> /dev/sdb3 /dev/sdf3 differ: byte 1, line 1
> /dev/sdb3 /dev/sdg3 differ: byte 1, line 1
> /dev/sdb3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdc3 /dev/sda3 differ: byte 262145, line 2
> /dev/sdc3 /dev/sdb3 differ: byte 1, line 1
> /dev/sdc3 /dev/sdd3 differ: byte 1, line 1
> /dev/sdc3 /dev/sde3 differ: byte 1, line 1
> /dev/sdc3 /dev/sdf3 differ: byte 262145, line 2
> /dev/sdc3 and /dev/sdg3 seem to match
> /dev/sdc3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdd3 /dev/sda3 differ: byte 1, line 1
> /dev/sdd3 /dev/sdb3 differ: byte 1, line 1
> /dev/sdd3 /dev/sdc3 differ: byte 1, line 1
> /dev/sdd3 /dev/sde3 differ: byte 1, line 1
> /dev/sdd3 /dev/sdf3 differ: byte 1, line 1
> /dev/sdd3 /dev/sdg3 differ: byte 1, line 1
> /dev/sdd3 and /dev/sdh3 seem to match
> /dev/sde3 /dev/sda3 differ: byte 262145, line 2
> /dev/sde3 /dev/sdb3 differ: byte 1, line 1
> /dev/sde3 and /dev/sdc3 seem to match
> /dev/sde3 /dev/sdd3 differ: byte 1, line 1
> /dev/sde3 /dev/sdf3 differ: byte 262145, line 2
> /dev/sde3 /dev/sdg3 differ: byte 262145, line 2
> /dev/sde3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdf3 /dev/sda3 differ: byte 1, line 1
> /dev/sdf3 /dev/sdb3 differ: byte 1, line 1
> /dev/sdf3 /dev/sdc3 differ: byte 1, line 1
> /dev/sdf3 and /dev/sdd3 seem to match
> /dev/sdf3 /dev/sde3 differ: byte 1, line 1
> /dev/sdf3 /dev/sdg3 differ: byte 1, line 1
> /dev/sdf3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdg3 and /dev/sda3 seem to match
> /dev/sdg3 /dev/sdb3 differ: byte 1, line 1
> /dev/sdg3 /dev/sdc3 differ: byte 262145, line 2
> /dev/sdg3 /dev/sdd3 differ: byte 1, line 1
> /dev/sdg3 /dev/sde3 differ: byte 1, line 1
> /dev/sdg3 /dev/sdf3 differ: byte 262145, line 2
> /dev/sdg3 /dev/sdh3 differ: byte 1, line 1
> /dev/sdh3 /dev/sda3 differ: byte 1, line 1
> /dev/sdh3 and /dev/sdb3 seem to match
> /dev/sdh3 /dev/sdc3 differ: byte 1, line 1
> /dev/sdh3 /dev/sdd3 differ: byte 1, line 1
> /dev/sdh3 /dev/sde3 differ: byte 1, line 1
> /dev/sdh3 /dev/sdf3 differ: byte 1, line 1
> /dev/sdh3 /dev/sdg3 differ: byte 1, line 1
>=20
> I manage recover my luks+xfs with this --create command \o/
> > mdadm --create /dev/md1 --metadata=3D1.0 -l10 -n8 --chunk=3D256
> --layout=3Df2 --assume-clean /dev/sdh3 /dev/sdb3 /dev/sde3 /dev/sdc3
> /dev/sdg3 /dev/sda3 /dev/sdf3 /dev/sdd3

cool!!  I love it when something like that produces a nice clean usable
result.

>=20
> Thank you Neil for your assistance you rock! With regards to my
> /etc/mdadm.conf the explicit references to the sd drives was generated
> with 'mdadm -Esv', my question is do you suggest I not even populate
> /etc/mdadm.conf with such output because of change in drives and just
> use 'mdadm -s -A /dev/mdX'? Also after running into this nasty bug I get
> the feeling that I should really keep a copy of all my future 'mdadm
> --create ...' commands handy just for such situations, do you agree?

The output of '-Ds' and '-Es' was only ever meant to be a starting point for
mdadm.conf, not the final content..

I think it is good to populate mdadm.conf, though in simple cases it isn't
essential.
I would just list the UUID for each array:
   ARRAY /dev/md0 uuid=3D.......
and leave it at that.

Keeping a copy of the output of "mdadm -E" of each device could occasionally
be useful.  You would need to update this copy any time any config change
happened to the array such as a device failure or a spare being added.

Glad it all worked out!

NeilBrown


>=20
> Thanks again and have a GREAT weekend.
> Fernando Vasquez a.k.a likewhoa


--Sig_/hYoZXEaQmbBihzMl_Fibs.H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5xhDDnsnt1WYoG5AQJtCw//UmZbPF97BtJw2UUp+gzxLglBxjOzj0Gh
d7maYg0/2FKgTedtm9QuK0ukzMblZAeR8/iNePnTB5VDHnNLPloawHJVN3RMZqpf
q4eKs1mB55cwxrs9+o4ZoGmSc0F0g1B3FZUrmScwdgjciX0lz6PfYiZl0YXS6NsA
iZCFjSeeZ75ZxK79tZnbtC2aWQNWN+T/GPYaJgvj/8qAKM/hd14Y5JgLIq5ubsyN
YpPT8LIvzq4sENTTfvCRd82m0eWFj3IQERZy6/xLjNS7LVYBLRPiu3kzcoMTfT4c
sU7fXbE3n4SwG3+2MWLCxc96gzDDAiH5UryTVd1cfgKli7n9zzBV4Z/6G5yDotQH
zNODb+z2t9xRHMaM4QviuIVqMWXlEcgzulBmKdgtSTDbGlPpJzQEw+RN3u/w6657
XPYzRoB4RtzBjCIq+4wFnQ1+FtnnYMAGbJL4ZFMkd6RWnv4nlF153+IYMqiLrrfM
J8i+xxFcHpompFCOxg5xRT5jupS9xVEWU/Nsf3jNMUzurl8PWTq0JT02QSMxPacz
rv2dSyE/leZJ2EHWWl51tDkZjvRv7oXJNdW7In4gV/yInDe/pQUN9Q6F9r6BBeOz
GzO9CYgGKMnyNQQ2vrt2XNPP+bGsBVFuG0Z3613N/mQg2/DYw6MqHBIiMKabNSpj
6KeYZNU/jvc=
=uoIS
-----END PGP SIGNATURE-----

--Sig_/hYoZXEaQmbBihzMl_Fibs.H--
