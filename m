From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Fri, 11 May 2012 10:50:27 +1000
Message-ID: <20120511105027.34e95833@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//Kplu1LFX4kvK9UtpuGc=Fu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//Kplu1LFX4kvK9UtpuGc=Fu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 19:16:59 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> Neil, can you please comment if separate operations mentioned in this
> process are behaving and are stable enough as we expect? Thanks.

The conversion to and from RAID6 as described should work as expected, thou=
gh
it requires having an extra device and requires to 'recovery' cycles.
Specifying the number of --raid-devices is not necessary.  When you convert
RAID5 to RAID6, mdadm assumes you are increasing number of devices by 1
unless you say otherwise.  Similarly with RAID6->RAID5 the assumption is a
decrease by 1.

Doing an in-place reshape with the new 3.3 code should work, though with a
softer "should" than above.  We will only know that it is "stable" when eno=
ugh
people (such as yourself) try it and report success.  If anything does go
wrong I would of course help you to put the array back together but I can
never guarantee no data loss.  You wouldn't be the first to test the code on
live data, but you would be the second that I have heard of.

The in-place reshape is not yet supported by mdadm but it is very easy to
manage directly.  Just
   echo replaceable > /sys/block/mdXXX/md/dev-YYY/state
and as soon as a spare is available the replacement will happen.

NeilBrown


>=20
> On Thu, May 10, 2012 at 8:59 AM, David Brown <david.brown@hesbynett.no> w=
rote:
> > (I accidentally sent my first reply directly to the OP, and forgot the
> > mailing list - I'm adding it back now, because I don't want the OP to f=
ollow
> > my advice until others have confirmed or corrected it!)
> >
> >
> > On 09/05/2012 21:53, Patrik Horn=EDk wrote:
> >> Great suggestion, thanks.
> >>
> >> So I guess steps with exact parameters should be:
> >> 1, add spare S to RAID5 array
> >> 2, mdadm --grow /dev/mdX --level 6 --raid-devices N+1 --layout=3Dprese=
rve
> >> 3, remove faulty drive and add replacement, let it synchronize
> >> 4, possibly remove added spare S
> >> 5, mdadm --grow /dev/mdX --level 5 --raid-devices N
> >
> >
> > Yes, that's what I was thinking. =A0You are missing "2b - let it synchr=
onise".
>=20
> Sure :)
>=20
> > Of course, another possibility is that if you have the space in the sys=
tem
> > for another drive, you may want to convert to a full raid6 for the futu=
re.
> > =A0That way you have the extra safety built-in in advance. But that will
> > definitely lead to a re-shape.
>=20
> Actually I dont have free physical space, array already has 7 drives.
> For the process I need place the additional drive on table near the PC
> and cool it with fan standing by itself on table... :)
>=20
> >>
> >> My questions:
> >> - Are you sure steps 3, 4 and 5 would not cause reshaping?
> >
> > I /believe/ it will avoid a reshape, but I can't say I'm sure. =A0This =
is
> > stuff that I only know about in theory, and have not tried in practice.
> >
> >
> >>
> >> - My array has now left-symmetric layout, so after migration to RAID6
> >> it should be left-symmetric-6. Is RAID6 working without problem in
> >> degraded mode with this layout, no matter which one or two drives are
> >> missing?
> >>
> >
> > The layout will not affect the redundancy or the features of the raid -=
 it
> > will only (slightly) affect the speed of some operations.
>=20
> I know it should work, but it is probably configuration that is not
> used much by users, so maybe it is not tested as much as standard
> layouts. So the question was aiming more at practical experience and
> stability...
>=20
> >> - What happens in step 5 and how long does it take? (If it is without
> >> reshaping, it should only upgrade superblocks and thats it.)
> >
> > That is my understanding.
> >
> >
> >>
> >> - What happens if I dont remove spare S before migration back to
> >> RAID5? Will the array be reshaped and which drive will it make into
> >> spare? (If step 5 is instantaneous, there is no reason for that. But
> >> if it takes time, it is probably safer.)
> >>
> >
> > I /think/ that the extra disk will turn into a hot spare. =A0But I am g=
etting
> > out of my depth here - it all depends on how the disks get numbered and=
 how
> > that affects the layout, and I don't know the details here.
> >
> >
> >> So all and alll, what guys do you think is more reliable now, new
> >> hot-replace or these steps?
> >
> >
> > I too am very curious to hear opinions. =A0Hot-replace will certainly b=
e much
> > simpler and faster than these sorts of re-shaping - it's exactly the so=
rt of
> > situation the feature was designed for. =A0But I don't know if it is
> > considered stable and well-tested, or "bleeding edge".
> >
> > mvh.,
> >
> > David
> >
> >
> >
> >>
> >> Thanks.
> >>
> >> Patrik
> >>
> >> On Wed, May 9, 2012 at 8:09 AM, David Brown<david.brown@hesbynett.no>
> >> =A0wrote:
> >>> On 08/05/12 11:10, Patrik Horn=EDk wrote:
> >>>>
> >>>> Hello guys,
> >>>>
> >>>> I need to replace drive in big production RAID5 array and I am
> >>>> thinking about using new hot-replace feature added in kernel 3.3.
> >>>>
> >>>> Does someone have experience with it on big RAID5 arrays? Mine is 7 *
> >>>> 1.5 TB. What do you think about its status / stability / reliability?
> >>>> Do you recommend it on production data?
> >>>>
> >>>> Thanks.
> >>>>
> >>>
> >>> If you don't want to play with the "bleeding edge" features, you could
> >>> add
> >>> the disk and extend the array to RAID6, then remove the old drive. I
> >>> think
> >>> if you want to do it all without doing any re-shapes, however, then y=
ou'd
> >>> need a third drive (the extra drive could easily be an external USB d=
isk
> >>> if
> >>> needed - it will only be used for writing, and not for reading unless
> >>> there's another disk failure). =A0Start by adding the extra drive as =
a hot
> >>> spare, then re-shape your raid5 to raid6 in raid5+extra parity layout.
> >>> =A0Then
> >>> fail and remove the old drive. =A0Put the new drive into the box and =
add it
> >>> as
> >>> a hot spare. =A0It should automatically take its place in the raid5,
> >>> replacing
> >>> the old one. =A0Once it has been rebuilt, you can fail and remove the=
 extra
> >>> drive, then re-shape back to raid5.
> >>>
> >>> If things go horribly wrong, the external drive gives you your parity
> >>> protection.
> >>>
> >>> Of course, don't follow this plan until others here have commented on=
 it,
> >>> and either corrected or approved it.
> >>>
> >>> And make sure you have a good backup no matter what you decide to do.
> >>>
> >>> mvh.,
> >>>
> >>> David
> >>>
> >>
> >>
> >


--Sig_//Kplu1LFX4kvK9UtpuGc=Fu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6xiVDnsnt1WYoG5AQIykRAApI++15+CMC5I1dvH7IZvR2kTR62e0P7q
06Rjud4u2coiUmUJTVafQh0bNjhLt1iUHfN4wY9Y+xoCbjIctHMxkoabNOpA0yFW
BAEg9m7yEkyTtlg4BzOy6Msswp0H3Ome2uoxPGPEW0sXPPxvh7p3etTckZDzbPYm
hEqYdt3Hvjtt52t6EDUqoESFBDMG5pQaUU7g43nl1EWx7ln/dRw5q5TMhEd5YW14
dH/E4mOdwtKIZlxtbMdu022qqBUo7qPIPxSjjUcqkCBX2/xaz2cSRGs6GURUBio6
6q7KHVLtOHT+LNX1BL+uR5aW+tSd+876+kqRDQsFfX2bwSOL/lSMbQZQUEHvXhjQ
TngNHV5vq35GqQSU4+AyZ6BIujcgdEcLyUy/TcMNzXMHSaR5MPBnft7c75XAcEPr
oOYT2hlcRE4rydkY2jDQwMsKE7F/14UyGzBKrwo9+nlm/MEpjxQw5yZhD9u5eh5J
tOj2rJGp942G0XnNIkwgNxESYfFsS26VOqwV1PJ7gqYACMk2b/hShS8ZbbsZ5Kwr
5v1UVLwzneR1eo7jgTmtiITXLU3blR41oRR5kuzcCSZ7UtoYv0TnW81U/BP4d84W
ubJTROtKCSCtEAVdk36dG+scVSaJnGmR3Q5KLlFVgGIfdEipNP8J8818cy6btByX
55+FwL5VUVI=
=o+uB
-----END PGP SIGNATURE-----

--Sig_//Kplu1LFX4kvK9UtpuGc=Fu--
