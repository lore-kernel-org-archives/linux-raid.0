From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Thu, 20 Oct 2011 10:56:23 +1100
Message-ID: <20111020105623.7f8038c9@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
	<20110925201510.24e0f468@notabene.brown>
	<CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
	<20111012144531.7479596a@notabene.brown>
	<CAGRgLy5rkhfqnYHTt89f8QkigYPHDFdcciP2ZQp1tkcYq2wqNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DdF23VgCKM8yzLc.kJ7S_xC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5rkhfqnYHTt89f8QkigYPHDFdcciP2ZQp1tkcYq2wqNg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DdF23VgCKM8yzLc.kJ7S_xC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Oct 2011 14:01:16 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks, Neil.
> I experimented with --force switch, and I saw that when using this
> switch it is possible to start the array, even though I am sure that
> the data will be corrupted. Such as selecting stale drives (which have
> been replaced previously etc.)
> Can I have some indication that it is "relatively safe" to start the
> array with --force?
> For example, in the case of "dirty degraded", perhaps it might be
> relatively safe.
>=20
> What should I look at? The output of --examine? Or something else?

Yes, look at the output of examine.  Look particularly at update time and
event counts, but also at RAID raid level etc and the role in the array
played by each device.

Then choose the set of devices that you should are most likely to have
current data and given them to "mdadm --assemble --force".

Obviously if one device hasn't been updated for months, that is probably a
bad choice, while if one device is only a few minutes behind the others, th=
en
that is probably a good choice.

Normally there isn't much choice to be made, and the answer will be obvious.
But if you let devices fail and leave them lying around, or don't replace
them, then that can cause problems.

If you need to use --force  there might be some corruption.  Or there might
be none.  And there could be a lot.  But mdadm has know way of knowing.
Usually mdadm will do the best that is possible, but it cannot know how good
that is.

NeilBrown



>=20
> Thanks,
>   Alex.
>=20
>=20
> On Wed, Oct 12, 2011 at 5:45 AM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 11 Oct 2011 15:11:47 +0200 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hello Neil,
> >> can you please confirm for me something?
> >> In case the array is FAILED (when your enough() function returns 0) -
> >> for example, after simultaneous failure of all drives - then the only
> >> option to try to recover such array is to do:
> >> mdadm --stop
> >> and then attempt
> >> mdadm --assemble
> >>
> >> correct?
> >
> > Yes, though you will probably want a --force as well.
> >
> >>
> >> I did not see any other option to recover such array Incremental
> >> assemble doesn't work in that case, it simply adds back the drives as
> >> spares.
> >
> > In recent version of mdadm it shouldn't add them as spare. =A0It should=
 say
> > that it cannot add it and give up.
> >
> > NeilBrown
> >
> >
> >


--Sig_/DdF23VgCKM8yzLc.kJ7S_xC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp9jrTnsnt1WYoG5AQLGKw//R10JHZdbrB73NwNMUSUtuOypu35lwhjK
8ihxXHRlFbetPZcCa02KGvqeC/yJJEHwer60KKbVv52OSqVjxh8Mc/GWA4qMSrsT
Ag72pzblxw2QYp32JghnwKbbP/YtG2u1I0jiua+zptfce4CtFXxUT5Pg+Nhc3lUZ
GTEBi2P1to+BmCuF8QVh46+q6XJuoagXUo57BFLlPxaeuBtj2GOSF0gQgdBCf/E+
Fml7HgfYFuWxb2pucKawZX8wngoOGDcFAKEtt0Z7CQho+9dSeaChQLdCxwYbmgw3
+y2610hYezP/KjUc+ukc2cN4fDjy3Z/H+WGNSTnleejwGP9+TO0NBoUEQwilBBxQ
hlbcOOZ/evDUP61RJxPp8mm5nHgnyK8USU+W7nYHfFiNoV6xYVf0H2xv4v1ky7As
UNGQ0+hx7DukS7emBdMNooSoo5hRELqbwmQEHJJ27Rx4I1RuTp3hGJ8hzXy+WRul
17/8uV+zChhdj0h3/tDOnps0eR7fUoH5P8akPp6HKYIY+ACxtZlIdxwhi5R2sX/2
svVdTi7vkztJCrMOPqm+lqLLvVZjbDVwqODf9dJZO1Jw28NyI/KvuQYyDYEvy5cT
vg6LmcXLRRspBqQ+FEoRTaH+bgWytZnZzcCChX0KRGmp/0wcCyLLYotZ9szUX6gt
2JtPT9k7m+s=
=GmVP
-----END PGP SIGNATURE-----

--Sig_/DdF23VgCKM8yzLc.kJ7S_xC--
