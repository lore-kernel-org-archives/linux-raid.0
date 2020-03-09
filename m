From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: Need help with degraded raid 5
Date: Mon, 9 Mar 2020 09:39:10 +0100
Message-ID: <CA+res+QNzpMxsB1wwYvpigAOMua1oSdMhaf-7K9HajEnS-rcjQ@mail.gmail.com>
References: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
 <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com>
 <5E61354C.2090901@youngman.org.uk> <CALc6PW6HYK_6UAtUVz4nmXF=BOwRrkt9HQFb0wpL5BM8tU9N4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW6HYK_6UAtUVz4nmXF=BOwRrkt9HQFb0wpL5BM8tU9N4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Jinpu Wang <jinpuwang@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

William Morgan <therealbrewer@gmail.com> =E4=BA=8E2020=E5=B9=B43=E6=9C=886=
=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=8810:35=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Thu, Mar 5, 2020 at 11:22 AM Wols Lists <antlists@youngman.org.uk> wro=
te:
> >
> > On 05/03/20 14:53, Jinpu Wang wrote:
> > > "mdadm /dev/md0 -a /dev/sdl1"  should work for you to add the disk
> > > back to array, maybe you can check first with "mdadm -E /dev/sdl1" to
> > > make sure.
> >
> > Or better, --re-add or whatever the option is. If it can find the
> > relevant data in the superblock, like bitmap or journal or whatever, it
> > will just bring the disk up-to-date. If it can't, it functions just lik=
e
> > add, so you've lost nothing but might gain a lot.
> >
> > Cheers,
> > Wol
>
> I tried re-add and I get the following error:
>
> bill@bill-desk:~$ sudo mdadm /dev/md0 --re-add /dev/sdl1
> mdadm: Cannot open /dev/sdl1: Device or resource busy
>
> sdl is not mounted, and it doesn't seem to be a device mapper issue:
>
> bill@bill-desk:~$ sudo dmsetup table
> No devices found
This is strange.
have you checked if any other process is using sdl1?
"sudo lsof /dev/sdl1"


>
> Here is the current state of sdl:
>
> bill@bill-desk:~$ sudo mdadm -E /dev/sdl1
> /dev/sdl1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x9
>      Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
>            Name : bill-desk:0  (local to host bill-desk)
>   Creation Time : Sat Sep 22 19:10:10 2018
>      Raid Level : raid5
>    Raid Devices : 4
>
>  Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
>      Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
>     Data Offset : 264192 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D264112 sectors, after=3D0 sectors
>           State : clean
>     Device UUID : 8c628aed:802a5dc8:9d8a8910:9794ec02
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Mar  2 17:41:32 2020
>   Bad Block Log : 512 entries available at offset 40 sectors - bad
> blocks present.
>        Checksum : 7b89f1e6 - correct
>          Events : 10749
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : spare
>    Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
>
The metadata looks fine.
If no one holds the disk, maybe last resort to zero out the metadata
and add the disk back, maybe first try David's suggestion, stop array
first and try re-add.
