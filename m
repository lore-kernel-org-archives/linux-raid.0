From: freeone3000 <freeone3000@gmail.com>
Subject: Re: Data Offset
Date: Fri, 1 Jun 2012 19:48:41 -0500
Message-ID: <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
 <20120602095237.3822e2c2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120602095237.3822e2c2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry.

/dev/sde fell out of the array, so I replaced the physical drive with
what is now /dev/sdf. udev may have relabelled the drive - smartctl
states that the drive that is now /dev/sde works fine.
/dev/sdf is a new drive. /dev/sdf has a single, whole-disk partition
with type marked as raid. It is physically larger than the others.

/dev/sdf1 doesn't have a mdadm superblock. /dev/sdf seems to, so I
gave output of that device instead of /dev/sdf1, despite the
partition. Whole-drive RAID is fine, if it gets it working.

What I'm attempting to do is rebuild the RAID from the data from the
other four drives, and bring the RAID back up without losing any of
the data. /dev/sdb3, /dev/sdc3, /dev/sdd3, and what is now /dev/sde3
should be used to rebuild the array, with /dev/sdf as a new drive. If
I can get the array back up with all my data and all five drives in
use, I'll be very happy.

On Fri, Jun 1, 2012 at 6:52 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 1 Jun 2012 18:22:33 -0500 freeone3000 <freeone3000@gmail.com>=
 wrote:
>
>> Hello. I have an issue concerning a broken RAID of unsure pedigree.
>> Examining the drives tells me the block sizes are not the same, as
>> listed in the email.
>>
>> > I certainly won't be easy. =C2=A0Though if someone did find themse=
lves in that
>> > situation it might motivate me to enhance mdadm in some way to mak=
e it easily
>> > fixable.
>>
>> I seem to be your motivation for making this situation fixable.
>> Somehow I managed to get drives with an invalid block size. All work=
ed
>> fine until a drive dropped out of the RAID5. When attempting to
>> replace, I can re-create the RAID, but it cannot be of the same size
>> because the 1024-sector drives are "too small" when changed to
>> 2048-sector, exactly as described. Are there any recovery options I
>> could try, including simply editing the header?
>
> You seem to be leaving out some important information.
> The "mdadm --examine" of all the drives is good - thanks - but what e=
xactly
> if your problem, and what were you trying to do?
>
> You appear to have a 5-device RAID5 of which one device (sde3) fell o=
ut of
> the array on or shortly after 23rd May, 3 drives are working fine, an=
d one -
> sdf (not sdf3??) - is a confused spare....
>
> What exactly did you do to sdf?
>
> NeilBrown
>
>
>>
>>
>> mdadm --examine of all drives in the RAID:
>>
>> /dev/sdb3:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 Data Offset : 2048 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 872097fa:3ae66ab4:ed21256a:10a030c9
>>
>> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 6d627f7a - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : Active device 1
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 Data Offset : 2048 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 2ea285a1:a2342c24:ffec56a2:ba6fcf07
>>
>> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fae2ea42 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : Active device 0
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>> /dev/sdc3:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 Data Offset : 2048 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 2ea285a1:a2342c24:ffec56a2:ba6fcf07
>>
>> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fae2ea42 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : Active device 0
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>>
>> /dev/sdd3:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 =C2=A0 Data Offset : 1024 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 8d656a1d:bbb1da37:edaf4011:1af2bbb9
>>
>> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : ab4c6863 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : Active device 3
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>> /dev/sde3:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 =C2=A0 Data Offset : 1024 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 37bb83bd:313c9381:cabff9d0:60bd205c
>>
>> =C2=A0 =C2=A0 Update Time : Wed May 23 03:30:50 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : f72e6959 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2004256
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : spare
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>> /dev/sdf:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 =C2=A0 Feature Map : 0x0
>> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(loc=
al to host leyline)
>> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 5
>>
>> =C2=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB=
)
>> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
>> =C2=A0 =C2=A0 Data Offset : 2048 sectors
>> =C2=A0 =C2=A0Super Offset : 8 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : e16d4103:cd11cc3b:bb6ee12e:5ad0a6e9
>>
>> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : e287a82a - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>>
>> =C2=A0 =C2=A0Device Role : spare
>> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D miss=
ing)
>>
>> --
>> James Moore
>>
>> --
>> James Moore
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>



--=20
James Moore
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
