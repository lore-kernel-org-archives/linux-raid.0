From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Temporarily Disable Array
Date: Wed, 9 Feb 2011 18:37:42 -0600
Message-ID: <02.05.13137.953335D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTi=wMnKhZCMan-TnA=RqCMhNrZ52bzXdK8hq7quF@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=wMnKhZCMan-TnA=RqCMhNrZ52bzXdK8hq7quF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: hansbkk@gmail.com [mailto:hansbkk@gmail.com]
> Sent: Wednesday, February 09, 2011 1:09 PM
> To: lrhorer@satx.rr.com
> Cc: Linux RAID
> Subject: Re: Temporarily Disable Array
>=20
> On Tue, Feb 8, 2011 at 7:14 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> >> From: hansbkk@gmail.com [mailto:hansbkk@gmail.com]
> >> FFR did you do this and did it work?
> >
> >        I did, but it didn't work as I had planned.  About a year ag=
o, I
> ran
> > across a bug that had caused the homehost field on the arrays to ga=
ve a
> pair
>=20
>=20
> Thanks for the update Leslie.  Assuming your specific issues didn't
> arise, is this checklist complete, or did you find you needed to do
> something else to prevent auto-assembly?

	I really don't know, for certain.  I was having so many other
issues, I'm not sure if this would have been entirely sufficient, or no=
t.  I
think so, but I could not swear to it.

> ------------------------------
>=20
> >> > 1. =A0Edit /etc/mdadm/mdadm.conf and comment out the line specif=
ying
> the
> >> > array. =A0Also comment out the line "HOMEHOST <system>"
> >> >
> >> > 2. =A0Edit /etc/fstab and comment out the line specifying the mo=
unt
> point
> >> for
> >> > the array.
> >> >
> >> > 3. =A0Issue the command `update-initramfs -u`
> >> >
> >> > 4. =A0Reboot the system, making sure the array does not assemble=
=2E
> >> >
> >> > 5. =A0Perform the OS upgrade.
> >> >
> >> > 6. =A0Edit mdadm.conf and fstab, removing the comment markers pl=
aced in
> >> steps
> >> > 1 and 2.
> >> >
> >> > 7. =A0Issue the command `update-initramfs -u`
> >> >
> >> > 8. =A0Reboot the system, making sure the array assembles and mou=
nts.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
