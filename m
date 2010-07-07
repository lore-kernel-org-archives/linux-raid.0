From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <csaba.toth@i3rendszerhaz.hu>
Subject: Re: convert raid10 to raid0
Date: Thu, 08 Jul 2010 01:34:03 +0200
Message-ID: <4C350EEB.1060302@i3rendszerhaz.hu>
References: <4C34D5AD.5020305@i3rendszerhaz.hu> <20100708085034.2bc8272e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100708085034.2bc8272e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

2010.07.08. 0:50 keltez=C3=A9ssel, Neil Brown =C3=ADrta:
> On Wed, 07 Jul 2010 21:29:49 +0200
> T=C3=B3th Csaba <csaba.toth@i3rendszerhaz.hu> wrote:
>=20
>> Hey List,
>>
>> i have a serious problem: have a file server with 4 disk (4x750GB),
>> using them in a software RAID10 array. One of the HDDs have a bad se=
ctor
>> (because some administration problems, i cannot replace them), and t=
he
>> motherboard sometimes drops the connection with two HDDs. Not with t=
he
>> same as the bad sector has, but with a resync i always managed the
>> problem. But now 3 drive form the RAID10 array dropped.
>>
>> In the past the sdc6 and the sdd6 partitions were the partitions i
>> resynced the others, so i know exactly where to look for the proper
>> datas. Can i use them as a RAID0 array somehow?
>=20
> It should be sufficient to:
>   mdadm -S /dev/md5
>   mdadm -C /dev/md5 --level raid0 --raid-devices 2 --chunk 512 \
>       --metadata=3D1.1 /dev/sdc6 /dev/sdd6
>=20
> to get your data available.
> There is a possible small complication though.  If you use a differen=
t
> version of mdadm to the one you used to create the array at first, it=
 might
> choose a different 'data offset'.
> To be sure this doesn't happen, use
>=20
>  mdadm -E /dev/sdc6
>=20
> and take note of the "Data Offset".  It would probably be a good idea=
 to keep
> a copy of "mdadm -E" of all of the devices, just to be on the same si=
de.
>=20
> Then after you create the raid0, use the same command
>    mdadm -E /dev/sdc6
> to check the Data Offset again and make sure it is the same.
> I suspect it will be, so everything will be fine.
> However if it isn't don't try to access the array.   Post the details=
 and I'll
> figure out what to do next.
>=20

i have made a small test case:

DTADIR=3D/mnt/data
MDF=3D/dev/md8

dd bs=3D512 count=3D180000 if=3D/dev/zero of=3D${DTADIR}/a
dd bs=3D512 count=3D180000 if=3D/dev/zero of=3D${DTADIR}/b
dd bs=3D512 count=3D180000 if=3D/dev/zero of=3D${DTADIR}/c
dd bs=3D512 count=3D180000 if=3D/dev/zero of=3D${DTADIR}/d

losetup /dev/loop0 ${DTADIR}/a
losetup /dev/loop1 ${DTADIR}/b
losetup /dev/loop2 ${DTADIR}/c
losetup /dev/loop3 ${DTADIR}/d

mdadm --create ${MDF} --level=3D10 --metadata=3D1.1 \
 --raid-devices=3D4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
mkfs.ext4 ${MDF}

mkdir ${DTADIR}/tmp
mount ${MDF} ${DTADIR}/tmp
cp -a /etc ${DTADIR}/tmp
umount ${MDF}

mdadm -S ${MDF}
mdadm -C /dev/md5 --level raid0 --raid-devices 2 --chunk 512 \
--metadata=3D1.1 /dev/loop0 /dev/loop3

mount ${MDF} ${DTADIR}/tmp
ls -al ${DTADIR}/tmp

umount ${MDF}
mdadm -S ${MDF}
losetup --detach /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3



i used loop0 and loop3 to construct the raid0 array, because they were
at the same (0 and 3) position than the devices i had in my real raid10
array. so this should work, but not :(
but after i made a raid0 array, and than recreate the raid10 array it
worked well. can't i create a raid10 array with two drives?

regards,
Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
