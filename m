From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Temporarily Disable Array
Date: Mon, 7 Feb 2011 18:14:37 -0600
Message-ID: <4E.7A.13137.FEA805D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTiktOdqq5Y3OWvU5dusDy+t_guEo88jm=DN-HnR8@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktOdqq5Y3OWvU5dusDy+t_guEo88jm=DN-HnR8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: hansbkk@gmail.com [mailto:hansbkk@gmail.com]
> Sent: Sunday, February 06, 2011 9:07 AM
> To: lrhorer@satx.rr.com
> Subject: Re: Temporarily Disable Array
>=20
> I assume no one every replied (and I can't comment other than "sounds
> good to me" 8-)
>=20
> FFR did you do this and did it work?

	I did, but it didn't work as I had planned.  About a year ago, I ran
across a bug that had caused the homehost field on the arrays to gave a=
 pair
of single quote marks in it.  Upon upgrade of mdadm, this causes the
automatic assembly of the RAID arrays to fail.  I thought I had fixed t=
he
issue on all the arrays, but evidently not.  When I tried the upgrade, =
it
failed to boot.  I never even thought about the problem with the quote =
marks
until I finally ran it to ground.  If I had thought of the issue, it wo=
uld
have been fine, and I would have fixed it in a matter of minutes.  As i=
t
was, it took me two days to find the problem, because every time I woul=
d
move down one avenue for recovery, something else would prohibit me fro=
m
getting the system into a state where troubleshooting was practical.  I=
n the
mean time, all four arrays on the system suffered some fairly dastardly
abuse.  They all survived, however, if not entirely intact, then at lea=
st
with no more damage than could easily be fixed.  Most importantly, ther=
e was
no loss of data, other than a couple of battered superblocks and one sm=
all
array that had to be rebuilt.

	There was also one small issue with the boot array.  GRUB2 was able
to assemble it just fine so as to get through the boot, but then the ar=
ray
would not assemble for the kernel.  It turned out the newer mdadm was
insisting the metadata statement say, "0.90", instead of "0.9" in
mdadm.conf.
=20
> On Sat, Feb 5, 2011 at 11:44 AM, Leslie Rhorer <lrhorer@satx.rr.com>
> wrote:
> >
> > =A0 =A0 =A0 =A0In a few days, I am going to be upgrading Linux on o=
ne of my
> servers
> > from Debian "Lenny" to "Squeeze". =A0I've gone through this upgrade=
 a
> handful
> > of times, and it can be pretty tricky. =A0It would be best if the d=
ata
> array
> > were not assembled over and over again during the process. =A0I kno=
w it
> really
> > shouldn't make a difference, but in the real world stability issues=
 have
> > raised their ugly heads more than once causing additional time and
> heartache
> > associated with the array to be required to complete the task. =A0W=
ith
> this in
> > mind, I would like to temporarily disable the assembly of the array
> until
> > the upgrade is complete and the system stable. =A0Do I have the fol=
lowing
> > checklist correct, or is there something wrong or missing? =A0Are t=
here
> better
> > alternatives? =A0I'm not missing something about the "homehost" uti=
lity,
> am I?
> >
> > 1. =A0Edit /etc/mdadm/mdadm.conf and comment out the line specifyin=
g the
> > array. =A0Also comment out the line "HOMEHOST <system>"
> >
> > 2. =A0Edit /etc/fstab and comment out the line specifying the mount=
 point
> for
> > the array.
> >
> > 3. =A0Issue the command `update-initramfs -u`
> >
> > 4. =A0Reboot the system, making sure the array does not assemble.
> >
> > 5. =A0Perform the OS upgrade.
> >
> > 6. =A0Edit mdadm.conf and fstab, removing the comment markers place=
d in
> steps
> > 1 and 2.
> >
> > 7. =A0Issue the command `update-initramfs -u`
> >
> > 8. =A0Reboot the system, making sure the array assembles and mounts=
=2E

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
