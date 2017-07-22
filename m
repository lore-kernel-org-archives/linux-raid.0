From: NeilBrown <neilb@suse.com>
Subject: Re: Linear device of two arrays
Date: Sun, 23 Jul 2017 09:03:33 +1000
Message-ID: <871sp8xeey.fsf@notabene.neil.brown.name>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com> <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk> <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com> <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org> <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com> <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org> <87van15j9b.fsf@notabene.neil.brown.name> <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com> <87o9sn232n.fsf@notabene.neil.brown.name> <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com> <87shhyzhg5.fsf@notabene.neil.brown.name> <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com> <87d18uydir.fsf@notabene.neil.brown.name> <be3ba727-2456-3507-e6d8-5b46d8b64339@gmail.com> <cc2ff16e-5368-b828-6acc-6698d6e0b52
 1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cc2ff16e-5368-b828-6acc-6698d6e0b521@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21 2017, Veljko wrote:

> Hello Neil,
>
> On 07/21/2017 11:15 AM, Veljko wrote:
>>> On 07/21/2017 12:00 AM, NeilBrown wrote:
>>> Bother.
>>>  mdadm uses "parse_size()" to parse the offset, and this rejects
>>>  "0", which makes sense for a size, but not for an offset.
>>>
>>>  Just leave the "--data-offset=3D0" out. I checked and that is defintely
>>>  the default for 1.0.
>>
>> Yes, now it works. I was able to create new linear device, restored the
>> saved 3M file and grown xfs. It was really fast and indeed, I'm happy.
>>
>> Thank you very much, Neil!
>
>
> Well, not without problems, it seams.
>
> I was having problem with root partition that was mounted read-only=20
> because of some problem with ext4. After fixing that on reboot, I still=20
> have extra space that was added with 4 new drives, but there are no md3=20
> or md4. I'm mounting this device in fstab with UUID. I noticed that UUID=
=20
> for md4 was the same as md2 before rebooting. But if I use array UUID=20
> from examine of md2 (first member of linear raid), I get:
>
>     mount: can't find UUID=3D"24843a41:8f84ee37:869fbe7b:bc953b58"
>
> The one that works and that is in fstab is that one for md2 in by-uuid=20
> below.

The UUID you give to mount is the UUID of the filesystem, not of the
device (or array) which stores the filesystem.

One of the problems with use 1.0 metadata (or 0.90) is that the first
component device looks like it contains the same filesystem as the whole
array.   I think this is what is causing your confusion.

>
>
> # cat /proc/mdstat
> Personalities : [raid1] [raid10]
> md2 : active raid10 sda4[4] sdd3[5] sdc3[7] sdb4[6]
>        5761631232 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>
> md1 : active raid10 sda3[4] sdd2[5] sdc2[7] sdb3[6]
>        97590272 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>
> md0 : active raid1 sda2[2] sdb2[3]
>        488128 blocks super 1.2 [2/2] [UU]
>
>
> No md3 or md4.
>
> Also, no mention of them in mdadm.conf
>
> # definitions of existing MD arrays
>   ARRAY /dev/md/0 metadata=3D1.2 UUID=3De5a17766:b4df544d:c2770d6e:214113=
ec=20
> name=3Dbackup1:0
>   ARRAY /dev/md/1 metadata=3D1.2 UUID=3D91560d5a:245bbc56:cc08b0ce:9c78fe=
a1=20
> name=3Dbackup1:1
>   ARRAY /dev/md/2 metadata=3D1.2 UUID=3Df6eeaa57:a55f36ff:6980a62a:d4781e=
44=20
> name=3Dbackup1:2

This all depends on the details of the particular distro you are using.
You don't, in general, need arrays to be listed in mdadm.conf.  A
particular distro could require it though.

If you run
   mdadm -Es

It will show a sample mdadm.conf which should contain /dev/md/3 - the
new raid10, and /dev/md/4.
You could add those lines to mdadm.conf, then
   mdadm --assemble /dev/md/3
   mdadm --assemble /dev/md/4
and it should get assembled.  Then you should be able to mount the large
filesystem successfully.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllz2ccACgkQOeye3VZi
gbnyHQ//SUguCTC5sPXQuY8nSJzdu1d5XPesIYn6qfN4fiTi38WLK8waVrBmDQbE
d6wNH42Jav4I20fWBMGm9dv746uoZRHHeJPjOkl5ngHwmLO6niSUFGYbVcrPDwak
ADNIxeU/rzPpR6O7EjPNwx3NPF4032x7o9LMGx1BMdTd83IEUxe28VQYo+nPM2oF
YtrOHO50dex/HCBp4ibEhtdA6huPNmeHwWkZDI1WBUix7Ri/2hRpDeTlRYZcXltV
jakhV2KqCOQtgBQ5K5+VkuuzeVXnnMkWA4pf7VcZenoJFD+QKevbyATjSGXPPj6v
dCWB+ZqS4gFc+hAmJrt3Ic/hGS89SZ3BR0n/2ldu43qe/pcfVtT+CIg51yVDCaF7
PAuFqHat6+1pWSuWSZGmzeLJo75WqL351RJzANzm+T7ysNWxYB65bFOlANOkuBju
3tHE+fk2DyLmtY4uXmV9FYlANqmQ6J2SdfII4ukzaCAU2BBIOHlZQoRupyuJ14Nt
hg+GdXTAwfFPcPKXMAQfd1Or8oabF+nY6rGVLpg222jGDatIyL9hvYuC4E3qlmXD
+lzE2Yrdn7aNPtVqzS5lzbdxcmYcvfMTCfUfhGXAc4wFnodZwVKR/aSs0BQSqyMq
Tolx8a58AjIh94K+Dn+AjEpjRbsRJHmEBDNIjRxzGkO7ejjeBxY=
=S7vz
-----END PGP SIGNATURE-----
--=-=-=--
