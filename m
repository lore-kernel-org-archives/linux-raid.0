From: Michal Soltys <soltys@ziu.info>
Subject: Re: LVM on raid10,f2 performance issues
Date: Wed, 03 Dec 2008 10:43:35 +0100
Message-ID: <493654C7.2090909@ziu.info>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4935C4B3.2060404@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Mauermann <mauermann@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Holger Mauermann wrote:
> Keld J=F8rn Simonsen schrieb:
>> How is it if you use the raid10,f2 without lvm?
>> What are the numbers?
>=20
> After a fresh installation LVM performance is now somewhat better. I
> don't know what was wrong before. However, it is still not as fast as
> the raid10...
>=20
> dd on raw devices
> -----------------
>=20
> raid10,f2:
>   read : 409 MB/s
>   write: 212 MB/s
>=20
> raid10,f2 + lvm:
>   read : 249 MB/s
>   write: 158 MB/s
>=20
>=20
> sda:  sdb:  sdc:  sdd:
> ----------------------
> YYYY  ....  ....  XXXX
> ....  ....  ....  ....
> XXXX  YYYY  ....  ....
> ....  ....  ....  ....



Regarding the layout from your first mail - this is how it's supposed t=
o=20
be. LVM's header took 3*64KB (you can control that with --metadatasize,=
=20
and verify with e.g. pvs -o+pe_start), and then the first 4MB extent=20
(controlled with --physicalextentsize) of the first logical volume=20
started - on sdd and continued on sda. Mirrored data was set "far" from=
=20
that, and shifted one disk to the right - as expected from raid10,f2.

As for performance, hmmm. Overally - there're few things to consider=20
when doing lvm on top of the raid:

- stripe vs. extent alignment
- stride vs. stripe vs. extent size
- filesystem's awareness that there's also raid a layer below
- lvm's readahead (iirc, only uppermost layer matters - functioning as =
a=20
hint for the filesystem)

But this is particulary important for raid with parities. Here=20
everything is aligned already, and parity doesn't exist.

But the last point can be relevant - and you did test with filesystem=20
after all. Try setting readahead with blockdev or lvchange (the latter=20
will be permananet across lv activations). E.g.

#lvchange -r 2048 /dev/mapper...

and compare to raw raid10:

#blockedv --setra 2048 /dev/md...

If you did your tests with ext2/3, also try to create it with -E stride=
=3D=20
stripe-width=3D option in both cases. Similary to sunit/swidth if you u=
sed=20
xfs.

You might also create volume group with larger extent - such as 512MB=20
(as 4MB granularity is often an overkill). Performance wise it shouldn'=
t=20
matter in this case though.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
