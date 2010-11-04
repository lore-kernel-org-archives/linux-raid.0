From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: mdadm / RAID, a few questions
Date: Thu, 4 Nov 2010 20:02:10 +0000
Message-ID: <AANLkTimybtn=_7+YQXEBYYWRcFoYycdz7rxCLHnSS6Ep@mail.gmail.com>
References: <AANLkTi=QRfQhNy5jDdtq2FsjENZk-ihNas=D4QrS2XMd@mail.gmail.com>
	<20101030074408.05392452@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101030074408.05392452@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thank you - it looks like it worked.

[root@ion ~]# mdadm  --examine --verbose --scan
ARRAY /dev/md/0 level=3Draid5 metadata=3D1.2 num-devices=3D6
UUID=3De6595c64:b3ae90b3:f01133ac:3f402d20 name=3Dion:0
   devices=3D/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/sdb=
1

Will run an fsck just in case.

Cheers,

// Mathias

On 29 October 2010 21:44, Neil Brown <neilb@suse.de> wrote:
> On Fri, 29 Oct 2010 15:18:09 +0100
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> Question 3: Before I created this RAID5 array I did a quick RAID0 te=
st
>> array just for fun, using 2 full devices (not partitions). Now I hav=
e
>> this:
>>
>> mdadm =C2=A0--examine --verbose --scan
>> ARRAY /dev/md/raid0-test level=3Draid0 metadata=3D1.2 num-devices=3D=
2
>> UUID=3Db84cc081:1ae27b49:d5ae466c:377ba300 name=3Dion:raid0-test
>> =C2=A0 =C2=A0devices=3D/dev/sdf,/dev/sdb
>> ARRAY /dev/md/0 level=3Draid5 metadata=3D1.2 num-devices=3D6
>> UUID=3De6595c64:b3ae90b3:f01133ac:3f402d20 name=3Dion:0
>> =C2=A0 =C2=A0devices=3D/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/=
sdc1,/dev/sdb1
>>
>> Is it safe to erase the raid0-test superblocks on device /dev/sdb an=
d
>> /dev/sdc or will it interfere with my RAID5 array (which is lying on
>> top of partitions) ?
>
> It should be safe to
> =C2=A0mdadm --zero-superblock /dev/sdf /dev/sdb
>
> As you have 1.2 metadata, that info will be 4K from the start of the =
device.
> Depending on how you partitioned the devices, that is either in dead =
space
> between the partition table and the first partition, or it is in dead=
 space
> in the first partition just before the md metadata.
>
> So the old metadata is still visible, creating the new arrays clearly=
 didn't
> over-write it, so they don't really care what is there...
>
> That statement isn't 100% general. A block in the data area of the ne=
w array
> could be unchanged by creating an array, yet changing it could still =
corrupt
> parity. =C2=A0However you can be certain that the metadata for a whol=
e-device
> array does not lie in the data area for a partitioned array of the sa=
me
> metadata type.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
