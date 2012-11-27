From: NeilBrown <neilb@suse.de>
Subject: Re: System runs with RAID but fails to reboot [explanation?]
Date: Tue, 27 Nov 2012 13:15:27 +1100
Message-ID: <20121127131527.4d0d81d5@notabene.brown>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	<20121122155236.0e7689c6@notabene.brown>
	<1353716131.18439.29.camel@corn.betterworld.us>
	<1353973722.7078.51.camel@markov.biostat.ucsf.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WT_COsg=yOxO7tf4Vs62suJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353973722.7078.51.camel@markov.biostat.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WT_COsg=yOxO7tf4Vs62suJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Nov 2012 15:48:42 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> I may have an explanation for what happened, including why md0 and md1
> were treated differently.
> On Fri, 2012-11-23 at 16:15 -0800, Ross Boylan wrote:
> > On Thu, 2012-11-22 at 15:52 +1100, NeilBrown wrote:
> > > On Wed, 21 Nov 2012 08:58:57 -0800 Ross Boylan <ross@biostat.ucsf.edu=
> wrote:
> > >=20
> > > > I spent most of yesterday dealing with the failure of my (md) RAID
> > > > arrays to come up on reboot.  If anyone can explain what happened or
> > > > what I can do to avoid it, I'd appreciate it.  Also, I'd like to kn=
ow if
> > > > the failure of one device in a RAID 1 can contaminate the other wit=
h bad
> > > > data (I think the answer must be yes, in general, but I can hope).
> > > >=20
> > > > In particular, I'll need to reinsert the disks I removed (described
> > > > below) without getting everything screwed up.
> > > >=20
> > > > Linux 2.6.32 amd64 kernel.
> > > >=20
> > > > I'll describe what I did for md1 first:
> > > >=20
> > > > 1. At the start, system has 3 physically identical disks. sda and s=
dc
> > > > are twins and sdb is unused, though partitioned. md1 is a raid1 of =
sda3
> > > > and sdc3.  Disks have DOS partitions.
> > > > 2. Add 2 larger drives to the system.  They become sdd and sde.  Th=
ese 2
> > > > are physically identical to each other, and bigger than the first b=
atch
> > > > of drives.
> > > > 3. GPT format the drives with larger partitions than sda.
> > > > 4. mdadm --fail /dev/md1 /dev/sdc3
> > > > 5. mdadm --add /dev/md1 /dev/sdd4.  Wait for sync.
> > > > 6. madadm --add /dev/md1 /dev/sde4.
> > > > 7. mdadm --grow /dev/md1 -n 3.  Wait for sync.
> > > >=20
> > > > md0 was same story except I only added sdd (and I used partitions s=
da1
> > > > and sdd2).
> > > >=20
> > > > This all seemed to be working fine.
> > > >=20
> > > > Reboot.
> > > >=20
> > > > System came up with md0 as sda1 and sdd2, as expected.
> > > > But md1 was the failed sdc3 only.  Note I did not remove the partit=
ion
> > > > from md1; maybe I needed to?
> First, the Debian initrd I'm using does recognize GPT partitions, and so
> unrecognized partitions did not cause the problem.
>=20
> Second, the initrd executes mdadm --assemble --scan --run --auto=3Dyes.
> This uses conf/conf.d/md and etc/mdadm/mdadm.conf.   The latter includes
> --num-devices for each array.

Yes, having an out-of-date "devices=3D" in mdadm.conf would cause the probl=
ems
you are having.  You don't really want that at all.


>                                 Since I did not regenerate this after
> changing the array sizes, it was 2 for both arrays.  man mdadm.conf says
> ARRAY  The ARRAY lines identify actual arrays.  The second word on  the
>     line  should  be  the name of the device where the array is nor-
>     mally assembled, such as /dev/md1.   Subsequent  words  identify
>     the  array,  or  identify  the  array as a member of a group. If
>     multiple identities are given,  then  a  component  device  must
>     match  ALL  identities  to be considered a match. [ num-devices is
> one of the identity keywords].
>=20
> This was fine for md0 (unless it should have been 3 because of the
> failed device),=20

It should be the number of "raid devices"  i.e. the number of active devices
when the array is optimal.  It ignores spares.

>                 and at least consistent with the metadata on sdc3,
> formerly part of md1.  It was inconsistent with the metadata for md1 on
> its current components, sda3, sdd4, and sde4, all of which indicates a
> size of 3 (or 4 if failed devices count).
>=20
> I do not know if the "must match" logic applies to --num-devices (since
> the manual says the option is mainly for compatibility with the output
> of --examine --scan), nor do I know if the --run option overrides the
> matching requirement.  But md0's components might match the num-devices
> in mdadm.conf, while md1's current components do not match. md1's old
> commponent does match.

Yes, "must match" means "must match".

And this is exactly what md1's old component was made into an array while t=
he
new components were ignored.

>=20
> I don't know if, before all that, udev triggers attempts to assemble
> arrays incrementally.  Nor do I know how such incremental assembly works
> when some of the candidate devices are out of date.

"mdadm -I" (run from udev) pays more attention to the uuid than "mdadm -A"
does - it can only assemble one array with a given uuid. (mdadm -A will
sometimes assemble 2.  That is the bug I mentioned in a previous email which
will be fixed in mdadm-3.3).

So it would see several devices with the same uuid, but some are inconsiste=
nt
with mdadm.conf so would be rejected (I think).

>=20
> So the mismatch between the array size for md0, but not md1, might
> explain why md0 came up as expected, but md1 came up as a single, old
> partition instead of the 3 current ones.

s/might/does/


>=20
> However, it is awkward for this account that after I set the array sizes
> to 1 for both md0 and md1 (using partitions from sda)--which would be
> inconsistent with the size in mdadm.conf--they both came up.  There were
> fewer choices at that point, since I had removed all the other disks.

I guess that as "all" the devices with a given UUID were consistent, mdadm =
-I
accepted them even as "not present in mdadm.conf".

>=20
> Third, my recent experience suggests something more is going on, and
> perhaps the count considerations just mentioned are not that important.
> I'll put what happened at the end, since it happened after everything
> else described here.
> > > >=20
> > > > Shutdown, removed disk sdc for the computer.  Reboot.
> > > > /md0 is reassembled to but md1 is not, and so the system can not not
> > > > come up (since root is on md0).  BTW, md1 is used as a PV for LVM; =
md0
> > > > is /boot.
> > > >=20
> > > > In at least some kernels the GPT partitions were not recognized in =
the
> > > > initrd of the boot process (Knoppix 6--same version of the kernel,
> > > > 2.6.32, as my system, though I'm not sure the kernel modules are sa=
me as
> > > > for Debian).  I'm not sure if the GPT partitions were recognized un=
der
> > > > Debian in the initrd, though they obviously were in the running sys=
tem
> > > > at the start.
> > >=20
> > > Well if your initrd doesn't recognise GPT, then that would explain yo=
ur
> > > problems.
> > I later found, using the Debian initrd, that arrays with fewer than the
> > expected number of devices (as in the n=3D paramter) do not get activat=
ed.
> > I think that's what you mean by "explain your problems." Or did you have
> > something else in mind?
> >=20
> > At least I  think I found arrays with missing parts are not activated;
> > perhaps there was something else about my operations from knoppix 7
> > (described 2 paragraps below this) that helped.
> >=20
> > The other problem with that discovery is that the first reboot activated
> > md1 with only 1 partition, even though md1 had never been configured
> > with <2.
> >=20
> > Most of my theories have the character of being consistent with some
> > behavior I saw and inconsistent with other observed behavior.  Possibly
> > I misperceived or misremembered something.
> > >=20
> > > >=20
> > > > After much trashing, I pulled all drives but sda and sdb.  This was
> > > > still not sufficient to boot because the md's wouldn't come up. md0=
 was
> > > > reported as assembled, but was not readable.  I'm pretty sure that =
was
> > > > because it wasn't activated (--run) since md was waiting for the
> > > > expected number of disks (2).  md1, as before, wasn't assembled at =
all.=20
> > > >=20
> > > > >From knoppix  (v7, 32 bit) I activated both md's and shrunk them t=
o size
> > > > 1 (--grow --force -n 1).  In retrospect this probably could have be=
en
> > > > done from the initrd.
> > > >=20
> > > > Then I was able to boot.
> > > >=20
> > > > I repartitioned sdb and added it to the RAID arrays.  This led to h=
ard
> > > > disk failures on sdb, though the arrays eventually were assembled. =
 I
> > > > failed and removed the sdb partitions from the arrays and shrunk th=
em.
> > > > I hope the bad sdb has not screwed up the good  sda.
> > >=20
> > > Its not entirely impossible (I've seen it happen) but it is very unli=
kely
> > > that hardware errors on one device will "infect" the other.
> > Our local sysadmin also believes the errors in sdb were either
> > corrected, or resulted in an error code, rather than ever sending bad
> > data back.  I'm proceeding on the assumption sda is OK.
> > >=20
> > > >=20
> > > > Thanks for any assistance you can offer.
> > >=20
> > > What sort of assistance are you after?
> > I'm trying to understand what happened and how to avoid having it happen
> > again.
> >=20
> > I'm also trying to understand under what conditions it is safe to insert
> > disks that have out of date versions of arrays in them.
> >=20
> > >=20
> > > first questions is: does the initrd handle GPT.  If not, fix that fir=
st.
> > That is the first thing I'll check when I'm at the machine.  The problem
> > with the "initrd didn't recognize GPT theory" was that in my very first
> > reboot md0 was assemebled from two partitions, one of which was on a GPT
> > disk. (another example of "all my theories have contradictory evidence")
> >=20
> > Ross
> After running for awhile with both RAIDs having size 1 and using sda
> exclusively, I shut down the sytem, removed the physically failing sdb,
> and added the 2 GPT disks, formerly known as sdd and sde.  sdd has
> partitions that were part of md0 and md1; sde has a partition that was
> part of md1.  For simplicity I'll continue to refer to them as sdd and
> sde, even though they were called sdb and sdc in the new configuration.
>=20
> This time, md0 came up with sdd2 (which is old) only and md1 came up
> correctly with sda3 only.  Substantively sdd2 and sda1 are identical,
> since they hold /boot and there have been no recent changes to it. =20
>=20
> This happened across 2 consecutive boots.  Once again, the older device
> (sdd2) was activated in preference to the newer one (sda1).
>=20
> In terms of counts for md0, mdadm.conf continued to indicate 2; sda1
> indicates 1 device; and sdd2 indicates 2 devices + 1 failed device.

That is why mdadm preferred sdd2 to sda1 - it matched mdadm.conf better.

I strongly suggest that you remove all "devices=3D" entries from mdadm.conf.

NeilBrown


>=20
> BTW, by using break=3Dbottom as a kernel parameter one can interrupt the
> initrd just after mdadm has run and see if the mappings are right.  For
> the 2nd boot I did just that, and then manually shutdown md0 and brought
> it back with sda1.  The code appears to offer break=3Dpost-mdadm as an
> alternative, but that did not work for me (there was no break).  These
> are Debian-specific tweaks, I believe.
>=20
> Ross


--Sig_/WT_COsg=yOxO7tf4Vs62suJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQiPznsnt1WYoG5AQIOWRAArrNTNTY2O54C39NvEP20E9QDs4JT60Ia
FcIdH076n2FuoJdTKyFv9s2f3MT4so7XVYfIZmyMdOLYDD8uNief8HIYaNJLciqX
72vS6LogHo4+0sdKzHZ8eNhJsYDUMLINFIXi7jQdZB86/3bEo0IRkbvRu+II0MuC
YSL6guSeN7HFFtd96r+ImNdGPlRRt/hgSFHsmPjCN/X6TArFyQQD6n4iyJIhYtm1
2lH+n43Lz3aI0jD6iMfyFbcBAEjA2him0jnkJSKNpXMNELRTCG8F7S1xxGA7l9sS
VBsHcKbNFOgp8Yr7GUs4G7AW7TMpCW2k+KHDur7rPi7mgZc5srse9SxUwFA5hvm5
JvgrIDcLgRLZSgkxLlCiwsDTJoE4vpEvrtAhh7YaIEkFdZw+0cLYL2YqUYkQ/lMD
KSo11r6q94hGtTRFElPtdptJa/TNVrhi/qliOG1gSWJuGMtgp+BZtYQkGlnqNZz9
3gF4MpXi7yeS2vXw9ureC8hzc+6YrZfXuqRt1dFDMMDACQ/1RQKizrx72UBrUbCv
WNqybsAtpB8Xm+hEUq6kBqKbKUBbe7MII41TQXRmx89K6/vLMO0xO+iNojQmcrOA
XzU4zNdK+qC59F/85epuMt2KZLtaMV//YcHrYK9TAIBbISpwhn2m9RDkPxBtTfD4
iT1diP0SUV8=
=95/0
-----END PGP SIGNATURE-----

--Sig_/WT_COsg=yOxO7tf4Vs62suJ--
