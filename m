From: NeilBrown <neilb@suse.de>
Subject: Re: All spares in Raid 5, default chunk? version of mdadm
 significant?
Date: Tue, 26 Jun 2012 09:33:17 +1000
Message-ID: <20120626093317.20c7e6ee@notabene.brown>
References: <CAK-d5dYwa69wcSGX-u97WmJbMceEX2D1wiXRea-mS+X+i9Dyyw@mail.gmail.com>
	<B619C027-FD5C-450E-8CE6-EDEC1D1092D6@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YlF3UQjgAoYcNQJ_SsaEQKG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B619C027-FD5C-450E-8CE6-EDEC1D1092D6@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YlF3UQjgAoYcNQJ_SsaEQKG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 12:20:06 +0530 Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:

> Hi all,
>  Hate to bump a thread but have I missed any information that would help =
to get me help :)?=20

I would generally recommend waiting 1 week before re-posting.  Things do
certainly get dropped so resending is important.  But sometimes people go
away for the weekend or are otherwise busy. :-(

>=20
> Neil,=20
>  as far as the default chunk sizes and mdadm versions are concerned, I am=
 guessing you may be amongst the few who would know that conclusively? Also=
 could the data offset and super offset be significant?

Well .... it is all in the source code in git.
A bit of hunting suggest the default chunk size changed from 64K to 512K ju=
st
after 3.1....


>=20
> Thanks,
> Anshu
>=20
> On 22-Jun-2012, at 5:50 PM, Anshuman Aggarwal wrote:
>=20
> > Hi,
> >  I have a 6 device raid 5 array which had 1 disk go bad and then due to=
 a power outage, the machine shutdown and when it started all the disks wer=
e showing up as spares with the following mdadm -E output (sample for one g=
iven below and full for all devices attached).

Yes ... sorry about that ... you've probably seen
http://neil.brown.name/blog/20120615073245

> >=20
> > This md device was part a Physical Volume for a LVM Volume Group.=20
> >=20
> > I am trying to recreate the array using mdadm --create --assume-clean u=
sing 1 device as missing. I am checking if the device is getting created co=
rrectly by checking the UUID of the created device which would match if the=
 device gets created correctly.
> >=20
> > I have tried a few combinations of the disk order that I believe is rig=
ht however I think I'm getting tripped up by the fact that the mdadm I used=
 to create this md device was some 2.x series and now we are on 3.x (and I =
may have taken some of the defaults originally which I don't' remember)
> > What all 'defaults' have changed over the versions so I can try those? =
Like chunk size? Can we manually configure the super/data offset? Are those=
 significant when we do an mdadm --create --assume-clean?

Chunk size was 64K with 2.x.  However your array was created in April 2010
which is after 3.1.1 was released, so you might have been using 3.1.x ??
The default metadata switch to 1.2 in Feb 2010 for mdadm-3.1.2.

You were definitely using 1.2 metadata as that info wasn't destroyed
(which implies a super offset of 4K (8 sectors).
So maybe you created the array with mdadm-3.1.2 or later implying a chunk
default chunk size of 512K.

The data offset has changed a couple of times and when you add a spare it
might get a different data-offset than the rest of the array.  However you
appear to have the data-offsets recorded in your metadata:

$ grep -E '(/dev/|Data Offset)' /tmp/md5.txt
/dev/sda5:
    Data Offset : 2048 sectors
/dev/sdb5:
    Data Offset : 2048 sectors
/dev/sdc5:
    Data Offset : 272 sectors
/dev/sdd5:
    Data Offset : 2048 sectors
/dev/sde5:
    Data Offset : 2048 sectors


'272' was old.  2048 is newer.

As you have differing data offsets you cannot recreate with any released
version of mdadm.
If you

 git clone git://neil.brown.name/mdadm -b data_offset
 cd mdadm
 make

Then try things like:

 ./mdadm -C /dev/md/RAID5_500G -l5 -n6 -c 512 --assume-clean \
     /dev/sda5:2048s /dev/sdb5:2048s missing /dev/sdc5:272s /dev/sdd5:2048s=
 \
     /dev/sde5:2048s

then try to assemble the volume group and check the filesystem.

I'm just guessing at the order and where to put the 'missing' device.  You
might know better - or might have a "RAID Conf printout" in recent kernel
logs which gives more hints.
The ":2048s" or ":272s" is specific to this "data_offset" version of mdadm
and tells it to set the data offset for that device to that many sectors.

You might need to try different permutations or different chunksizes until
the vg assembles properly and the 'fsck' reports everything is OK.

Good luck,

NeilBrown


> >=20
> > Thanks,
> > Anshu
> >=20
> > /dev/sda5:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : b480fe0c:c9e29256:0fcf1b0c:1f8c762c
> >            Name : GATEWAY:RAID5_500G
> >   Creation Time : Wed Apr 28 16:10:43 2010
> >      Raid Level : -unknown-
> >    Raid Devices : 0
> >=20
> >  Avail Dev Size : 976768002 (465.76 GiB 500.11 GB)
> >   Used Dev Size : 976765954 (465.76 GiB 500.10 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : active
> >     Device UUID : a8499a91:628ddde8:1cc8f4b9:749136f9
> >=20
> >     Update Time : Sat May 19 23:04:23 2012
> >        Checksum : 9950883c - correct
> >          Events : 1
> >=20
> >=20
> >    Device Role : spare
> >    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >=20
> > <md5.txt>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/YlF3UQjgAoYcNQJ_SsaEQKG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+j1PTnsnt1WYoG5AQL9Lg//Zi7awp3w2LC7F3Ms9A3EIZWYBKDE+Wzk
g+3LfUwVkFElnYjYStAx/fOgDbqZnHipMrFayLmKR/QBU3unVISEo3KiwBCZt/mF
1x8pCkWUmtwEeSL8GHMYisRiKTaGGEbqw6yHLMSUuK//bApQ7i2dI0CQIuoDE/o6
nu55vtHSfZxQgKWb8JAY5vVvnBhY7A5KnFiorFRxWQv5lytRvN88ROGnQ1snBPoS
tT3mKvZOS8+zG6rP2W6KyIQDv3/2jmEkjiZjeSgWjv6nOUHZAP/nUQJU2sct1+JB
Z2JdLA7cit+vRB8S3xtmhJFoxYFZbnpNFEbkIpz0kwlUtlLLHE4wa537PP8YUlBv
2KJ0zFun9D+nm58m4DPcxTJzvtDy91mBidU0bnetUDQiU90GbSi8FzneNJl66gfC
r04MrXhBiJJxz93vz288ZP3mIfNaOqdhF7ES77l4N4ChVm9eN0xRdmUYDxQx55kV
/bqPMMUGJ8yANaTMZmBubF4Q/IbqKh2+k9VESN3L6730CGSahG1PAvB5CJyzTNsJ
Tm7nSfXHgUr7QpRzu2K8Hz7e3WGmfkFW6NR08EwepwsW4OivU7CdsxNAuB6UlDFF
tNexN23OfiJnEVf/8io3/vSttIB1lTsyCVZ9pfP8F1ocdQStjS7b6nxxVNB2q3Jo
Wh5seS7lJZI=
=Rv9a
-----END PGP SIGNATURE-----

--Sig_/YlF3UQjgAoYcNQJ_SsaEQKG--
