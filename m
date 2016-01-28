From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm bad blocks list
Date: Thu, 28 Jan 2016 14:19:52 +1100
Message-ID: <87twly1jc7.fsf@notabene.neil.brown.name>
References: <56A9102D.4030304@prgmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A9102D.4030304@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Jan 28 2016, Sarah Newman wrote:

> I experienced the following problems with the mdadm bad blocks list:
>
> 1. Additions to the bad block list do not cause an email to be sent by the mdadm monitor. Expected behavior is for an email to be sent as soon as the
> bad blocks list becomes non-empty.

Yes, that would be a good idea.  If you do develop patches, please post
them.

> 2. /proc/mdstat does not show any indication that there are bad blocks present on an md member. Specifically, the status for the raid personality
> should show something other than "U" if the badblocks list is not empty for that member (maybe "B"?)

I'd like to deprecate /proc/mdstat.  It is not really easy to extend.
People might have programs that parse it which could break if you change
'U' to 'B'.
I'd recommend using "mdadm" to get status of an array, or examine file
in /sys.

> 3. Adding a device when there is an md member with bad blocks does not appear to trigger a rebuild, meaning there could be at least one good copy of
> all the data but no way to get all good data on a single device without expanding the entire array.

Good point.  That would be quite easy to change.  Just set
WantReplacement if the bad block list is ever empty.
Not sure it is always a good idea though.  You can have a bad block on a
perfectly good device if the device it was recovered from has a bad
block.
You only really want to set WantReplacement automatically if a write
fails.  We do do that, but if you stop and restart an array the fact
that a write failed can be forgotten.

>
> Kernel: CentOS 6 Xen4CentOS 3.18.21-17
> mdadm: CentOS 6 v3.3.2
>
> With the above behavior, I consider the bad blocks list to be actively harmful. If it's expected behavior in the current version, please consider
> disabling the bad blocks list by default.

You can do this yourself by putting

  CREATE bbl=no

in /etc/mdadm.conf.  That doesn't help others though.

I'm not convinced that it is harmful, though I accept that it is not perfect.

>  We might be able to provide some patches to correct 1. and 2. but we don't have anything ready right now.

That would be great if you could.
Thanks for your thoughts.

NeilBrown

>
> --Sarah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqYjYAAoJEDnsnt1WYoG5WAIQALWPb7ZTiQ68EN+u87vn71ZG
bgg+wHzGL7SHIefbAfieJot/x4660WLesO0zcJqHUBA/w1K2s6kXlSAOW+sVUE1i
lETR1oyPjytVQFodBh8GygAE39etKOI1EDNW8cgb9pkBm93LHNRcJgNZ21ZKdXgp
cUs4TrCHWTmdG0KUmeXkoRG9Xx21FhZWPqT7clO2fjVdCOYodQCOeTNQvWAs5oyW
w2o74e3QKHuBa5CLxODbw0Mqj+NcOXmCnvDK1ZYEay3FTKvpwhJlPUp8PWS1skDD
1r6ngPJcoTu32ViJCXF+AOltgRfPrFKo/qQGEFWVhGVgQhuHCuNdiMDCbGmYrXTy
J2J2mmPeihQ4yA4+GfwIAJxrw3aY3HzelVvebBTL2rGL18isEhzTA3xxPlcAecXP
/0Uet5cKyPXi8D1W9Pl0O4O++belMmDafiVfFSZTfoNbBRzc9S86re7QUblu26E3
XVxj0QYJtacMnG0vAK/g4+5OPCIqrs8p9HAXDxEPGWRjarYborCF1xR4VL08IVFe
qPUpkggght++jNWy0xXgVhtgX/GYZXUIlgoS4j/8xvS9Qm/NsZvpCUK9t1ICFBCe
TAyb+J3BF8+sj7QZ4YK0j9ojq6TO3sq72oKr/D+9MCUwLX4TeJ0pEwYNzp/8/gT3
Gfx7xcVxZOZaUQ3TtdB4
=0/Z1
-----END PGP SIGNATURE-----
--=-=-=--
