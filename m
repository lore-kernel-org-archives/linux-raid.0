From: NeilBrown <neilb@suse.com>
Subject: Re: The dev node can't be released at once after stopping raid
Date: Fri, 01 Sep 2017 14:34:13 +1000
Message-ID: <87fuc7dol6.fsf@notabene.neil.brown.name>
References: <1159964415.16461871.1496288839399.JavaMail.zimbra@redhat.com> <1471667815.16472496.1496296238179.JavaMail.zimbra@redhat.com> <1941784023.3852671.1504151717389.JavaMail.zimbra@redhat.com> <87bmmwfj5z.fsf@notabene.neil.brown.name> <1889255088.3872827.1504160273377.JavaMail.zimbra@redhat.com> <8760d4fd25.fsf@notabene.neil.brown.name> <716638049.3884368.1504163810231.JavaMail.zimbra@redhat.com> <87wp5je28m.fsf@notabene.neil.brown.name> <1154836302.4166794.1504225817475.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1154836302.4166794.1504225817475.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31 2017, Xiao Ni wrote:

>>=20
>> udev will create the device and multiple links.  You are just removing
>> the device.  Someone might come along and complain about the links.
>
> Sorry, could you explain "udev will create the device and multiple links"=
 in detail?=20
> Does it mean unlink can cause udev to re-create the device and multiple l=
inks? Or
> You mean it should remove other links by unlink too, not only the device?

If you have an md array assembled, run
  udevadm info /dev/mdWHATEVER | grep DEVLINKS

e.g.

$ udevadm info /dev/md0 | grep DEVLINKS
E: DEVLINKS=3D/dev/disk/by-id/md-uuid-4812bff9:24c9ef72:14a75d6a:bbcc0774 /=
dev/md/0 /dev/disk/by-id/md-name-any:0

Note that there are multiple names listed.
When the array appears, udev creates the device (/dev/md0 in this case)
and creates all the links pointing to the device.
When the array disappears, udev removes the device and the links.
You want to get mdadm to remove the device, but not the links.
That is, at best, half the job.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmo40YACgkQOeye3VZi
gbldvA/8DN7WwWuqBfamv9IWP/66zdXRZMvMlUVZkdVAzygqU4JeHkaENj61ktvN
XRpylFJlHUdBx1Tjorw8u3joetd8WiAtD6HWYJRwZ3h5vVNxonMec9+is4dWB7Yy
iwe+rvO2GpcWGNh+H3r5XpR9GRDYQHPSyUQwI9hrSEeQk/Qb1riX83TBrCCBKSoK
84JWfXv4MkQuFm7IZYLUSdSUK/WAVArTB8Y0uCcYpDvAn81lcr+GARDVWI2u+osg
9JGqL5nvemA4uRVrVEMO11u1P+KHIJk5guOlecxdBJHQEWR6TcrsgIUtrxNBZhqw
kHip1uXigeRz0APH11d9UBxMqkTHO3mCJjeEI3MPHWTNT+f2lOCg0CITt48VYapM
yNwOI1nhDvytUNxwBSVCSWTwdJzLY5PTmgg7XHfINQ+/X3Ddf70zJUMwT82riTPS
67fLc934sPeHEGEDo9v6kEIuflk5jl6+Um3y8mpsJsOq4asKBpTTQLVmiDg7W1sZ
MEo0EI9aGTTLP3XWzNIRtq7e2FPb0YBSye8xqCp399AoTSAiJyvGL4Ri8dhFdb0b
X658oHSJp+1J9KZFw+4OSfANuIODLmWXWsR7EbCcplEfL2e7FMQwpsZN+pY4r+hc
o+5lNTaOZjM8B6RxweGFww1uDwse2IA7PtkoFPyJ4wubnEVRqkY=
=33QC
-----END PGP SIGNATURE-----
--=-=-=--
