From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 28 Oct 2007 13:55:48 -0400
Message-ID: <1193594148.10336.413.camel@firewall.xsintricity.com>
References: <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com>
	 <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com>
	 <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <20071026091513.GB32550@percy.comedia.it>
	 <1193426793.10336.302.camel@firewall.xsintricity.com>
	 <20071027075054.GA12053@percy.comedia.it>
	 <1193518050.10336.343.camel@firewall.xsintricity.com>
	 <20071028133736.GA22861@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1Lho27jvqzE89UI8fYBx"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071028133736.GA22861@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-1Lho27jvqzE89UI8fYBx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-28 at 14:37 +0100, Luca Berra wrote:
> On Sat, Oct 27, 2007 at 04:47:30PM -0400, Doug Ledford wrote:

> >Most of the time it does.  But those times where it can fail, the
> >failure is due to not taking the precautions necessary to prevent it:
> >aka labeling disk usage via some sort of partition table/disklabel/etc.
> I strongly disagree.
> the failure is badly designed software.

Then you need to blame Ingo who made putting the superblock at the end
of the device the standard.  If the superblock were always at the
beginning, then this whole argument would be moot.  Things would be
reliable the way you want.

> >Using whole disk devices isn't a means of organizing space.  It's a way
> >to get a rather miniscule amount of space back by *not* organizing the
> >space.
> if i am using, say lvm to organize disk space, a partition table is
> unnecessary to the organization, and it is natural not using them.

If you are using straight lvm then you don't have this problem anyway.
Lvm doesn't allow the underlying physical device to *look* like a valid,
partitioned, single device.  Md does when the superblock is at the end.

> >This whole argument seems to boil down to you wanting to perfectly
> >optimize your system for your use case which includes controlling the
> >environment enough that you know it's safe to not partition your disks,
> >where as I argue that although this works in controlled environments, it
> >is known to have failure modes in other environments, and I would be
> >totally remiss if I recommended to my customers that they should take
> >the risk that you can ignore because of your controlled environment
> >since I know a lot of my customers *don't* have a controlled environment
> >such as you do.
>=20
> The whole argument to me boils down to the fact that not having a partiti=
on
> table on a device is possible, and software that do not consider this
> eventuality is flawed,

It's simply not possible to 100% certain differentiate between an md
whole disk partitioned device with a superblock at the end and a regular
device.  Period.  You can try to be clever, but you can also get tripped
up.  The flaw is not with the software, it's with a design that allowed
this to happen.

>  and recommnding to work-around flawed software is
> just digging your head in the sand.

If a design is broken but in place, I have no choice but to work around
it.  Anything else is just stupid.

> But i believe i did not convince you one ounce more than you convinced
> me, so i'll quit this thread which is getting too far.
>=20
> Regards,
> L.
>=20
> --=20
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-1Lho27jvqzE89UI8fYBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJM0kTzP9PM7pjw8RAoBHAJ9qPLlN+ENjKZ/aP5nfZ08b8qh2qwCfeaTn
7SI5wou90OLGm0B24uwGUGU=
=Uh+y
-----END PGP SIGNATURE-----

--=-1Lho27jvqzE89UI8fYBx--

