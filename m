From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
 	when creating containers. This allows a person to testing using loopback
 	devices that don't support serial number queries.
Date: Tue, 19 Jan 2010 00:31:56 -0500
Message-ID: <4B5543CC.3060901@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-2-git-send-email-dledford@redhat.com>	 <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>	 <4B55112F.4090403@redhat.com> <e9c3a7c21001182042k1a88e21fpc64ff0bb75ff5854@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58E1B2582DDA15D2E41D2977"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21001182042k1a88e21fpc64ff0bb75ff5854@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58E1B2582DDA15D2E41D2977
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/18/2010 11:42 PM, Dan Williams wrote:
> On Mon, Jan 18, 2010 at 6:55 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>> On 01/18/2010 05:13 PM, Dan Williams wrote:
>>> Hi Doug,
>>>
>>> On Mon, Jan 11, 2010 at 1:38 PM, Doug Ledford <dledford@redhat.com> w=
rote:
>>>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>>>> ---
>>>>  super-intel.c |    5 ++++-
>>>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/super-intel.c b/super-intel.c
>>>> index d6951cc..fcf438c 100644
>>>> --- a/super-intel.c
>>>> +++ b/super-intel.c
>>>> @@ -3208,7 +3208,10 @@ static int add_to_super_imsm(struct supertype=
 *st, mdu_disk_info_t *dk,
>>>>        dd->fd =3D fd;
>>>>        dd->e =3D NULL;
>>>>        rv =3D imsm_read_serial(fd, devname, dd->serial);
>>>> -       if (rv) {
>>>> +       if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
>>>> +               memset(dd->serial, 0, MAX_RAID_SERIAL_LEN);
>>>> +               fd2devname(fd, (char *) dd->serial);
>>>> +       } else if (rv) {
>>>
>>> This just duplicates the check already inside imsm_read_serial().
>>> Containers on loopback devices worked before this patch, so I'll send=

>>> a revert.
>>>
>>> --
>>> Dan
>>
>> Me thinks you didn't try it, because this does not duplicate the code =
in
>> imsm_read_serial().  That code is needed to assemble an IMSM array tha=
t
>> already exists on loopback devices.  This is needed to *create* an ims=
m
>> container on fresh loopback devices.  I'm assuming your imsm container=

>> superblocks already existed or some such.
>>
>=20
> Me thinks you did not try it either :-)
>=20
> # export IMSM_DEVNAME_AS_SERIAL=3D1
> # mdadm --zero-superblock /dev/loop[0-3]
> # mdadm -Eb /dev/loop[0-4]
> # mdadm -E /dev/loop0
> mdadm: No md superblock detected on /dev/loop0.
> # mdadm --create /dev/md/imsm /dev/loop[0-3] -n 4 -e imsm
> mdadm: /dev/loop0 appears to contain an ext2fs file system
>     size=3D306816K  mtime=3DSat Nov 21 10:54:51 2009
> mdadm: /dev/loop1 appears to contain an ext2fs file system
>     size=3D306816K  mtime=3DSat Nov 21 10:54:51 2009
> mdadm: imsm unable to enumerate platform support
>     array may not be compatible with hardware/firmware
> Continue creating array? y
> mdadm: container /dev/md/imsm prepared.
> # mdadm -Eb /dev/loop[0-3]
> ARRAY metadata=3Dimsm
>    spares=3D4
>=20
> # mdadm -E /dev/loop0
> /dev/loop0:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : 00000000
>          Family : 697a43ec
>      Generation : 00000001
>            UUID : ffffffff:ffffffff:ffffffff:ffffffff
>        Checksum : c3d8d367 correct
>     MPB Sectors : 1
>           Disks : 1
>    RAID Devices : 0
>=20
>   Disk00 Serial : /dev/loop0
>           State : spare
>              Id : 00000000
>     Usable Size : 204382 (99.81 MiB 104.64 MB)
>=20
> This is with:
> commit 6acad4811b06335a2602fa1eeaec3a8f47f96591
> Author: Michael Evan <mjevans1983@gmail.com>
> Date:   Wed Dec 9 21:52:18 2009 -0800
>=20
> --
> Dan

Ah, OK.  I did say we had been carrying this around in our SRPM for a
while, I just hadn't tried removing it since it was necessary.  I take
it you are implying that that changeset is the one that rendered it no
longer necessary?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig58E1B2582DDA15D2E41D2977
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVQ8wACgkQg6WylM+/8ZTg2wCfeYJY6U7zUYD2BqZkmU0NMyoj
C0AAnRW8ta6dnaNJxh02rUPUUo5HGtWO
=BZtW
-----END PGP SIGNATURE-----

--------------enig58E1B2582DDA15D2E41D2977--
