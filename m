From: NeilBrown <neilb@suse.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Mon, 23 Oct 2017 09:40:58 +1100
Message-ID: <8760b6g611.fsf@notabene.neil.brown.name>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com> <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com> <59E7AE4B.5000903@youngman.org.uk> <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com> <87zi8mg7mi.fsf@notabene.neil.brown.name> <e257fcc8-9773-a8a2-42bd-6030aef6329e@gmail.com> <87efpyfuz6.fsf@notabene.neil.brown.name> <78c21efa-2587-6ff3-5572-2d1a1b6d428d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <78c21efa-2587-6ff3-5572-2d1a1b6d428d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sfunk1x <sfunk1x@gmail.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 22 2017, sfunk1x wrote:

> On 10/19/2017 06:50 PM, NeilBrown wrote:
>
>> Thanks.  sdf looks like it might have a gpt partition
>> table on it.  The "od -x" supports that.  What does "fdisk -l /dev/sdf"
>> show? What about=20
>>   mdadm --examine /dev/sdf*
>> ??
>
> fdisk -l /dev/sdf:
>
> Disk /dev/sdf: 3000.6 GB, 3000592982016 bytes, 5860533168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
> Disk identifier: 5B742241-93F1-4FE1-9CA6-525F759E38B1
>
>
> #         Start          End    Size  Type            Name
>  1         2048   5860533134    2.7T  Linux RAID
>

This seems to suggest that you did prepare to use sdf1 (rather than sdf)
in the array, but it isn't conclusive proof.

>
> mdadm --examine /dev/sdf*
>
> /dev/sdf:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> mdadm: No md superblock detected on /dev/sdf1.

No metadata on sdf1 - sad.  That is what I was hoping for.

>
>
>
>>=20
>> I should have suggested " | head" at the end of the 'grep'
>> command.  Maybe make it
>>   od -x /dev/sdf | grep '4efc a92b' | head
>> That will look for md metadata.
>
> It's actually still running, but this is the output so far:
>
> [root@hemlock ~]# od -x /dev/sdf | grep '4efc a92b' | head
> 142401762260 7984 d854 643a 3c8f dd3a a8de 4efc a92b
> 156441541400 48f9 9523 3539 de0a d1f4 4efc a92b 60a8
> 214717071120 ac68 a62e 441c c0f8 85c1 cab7 4efc a92b
> 367526264660 dc8f 4f52 4efc a92b fd99 4744 1d6e c59f
> 515240166540 4f6a c1eb 5309 4efc a92b d0ad b3ee 11a0
> 575452271660 b669 7eeb 4efc a92b ebf5 c069 c78d 82d3
> 1026007653000 913f 4efc a92b 0b3d 5e94 9f7a 80a5 6e0c
> 1104130763160 7267 f0e5 e9a4 a9e0 0b85 5b3b 4efc a92b
> 1107535224640 cde4 efa8 557c 01a1 1abb b885 4efc a92b
> 1167200747300 49dd f3e2 4efc a92b a6e7 f1af 7af1 e6c6

No md metadata to be found at all.
We would need to see a line with an address ending "000" and data
starting  4efc a92b 0001 0000 ....
Nothing like that here.

Maybe this isn't really the drive you think it is?  Could  someone or
something have swapped drives?
Maybe you or someone zeroed the metadata (mdadm --zero-super /dev/sdf1).

There is no way that md or mdadm could have mis-behaved, even when
affected by selinux, to produce this result.  Something else must have
happened.  Maybe something you don't know about, or something you don't
think it relevant.  But there must be something.

Sorry I cannot be more helpful.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlntHnsACgkQOeye3VZi
gbmiOA/7BsrjwixxIL+GZ8yENUbOriyBco+5r/lzFT8/0zAbtmVQwUaa25/W5rNx
udxM/tjCDOpyqCLSYMeC4NMomtAxFw81dDyxsNFBLXCxvcZD25E/GWEE+4H2/wCB
CCkI89gMRTJuwVithpWjth1G9XbhK4rpZFODnTFEnsFzSHc7E/Pgxhnhnc9yYqiW
MdpwTwQYlSezUBxLPZZvBmalU2wyS3SzovzzXWo4ohR7cYqHNGwBrXAvtIC7aYHB
cue4GUE3LjxVYNwGTjLH1MJW5KjKHmji9zxfcIGJthvAImpVp0mqUw02FnCfnAXe
H4uqJ41HSKInG5Dr0IPSPJCpNWQOdgFtVAzFJKSC7dg2gpvWVYrHjq3afNiDoRT/
AEhz7Wq2hP71LzgMw1yzSxBu1Q+RVaakuwoUUN9p0l9qv/lWBh50iJVivDyh+zvZ
/ma8rKZGfA7AZgKyJ9q+SCKAGwmujvjCBSvm0w3sMUxTrYXCq37vnogNhNJ+/uE8
4K9s/efvscpHHyKCU0+jZQkA1aFdQ/M65eJZ1xSMfqmbnKB5S+9nBgckkLeq9AAv
fczz74iX31T04T+JFSOUFxf1LTeYenr9wHst5QMHH8NgUYwa67/iJgUaFfYPxljK
6mUL+cyi9lkLwJBW9bY129tDzf2fCfshO8vu01e8BBOKGq+fHoQ=
=lu3y
-----END PGP SIGNATURE-----
--=-=-=--
