From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 11:06:05 +0100
Message-ID: <4A5C588D.4000400@anonymous.org.uk>
References: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Beuchler <insyte@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/07/2009 08:16, Ben Beuchler wrote:
> I'd like to convert an existing partition to RAID 1 using a portion o=
f
> a new, blank drive.  All of the examples I've seen involve creating
> the RAID device with the *empty* partition (sda4), copying the data
> from the old partition to the new RAID, then adding the old partition
> to the RAID set.
>=20
>>From my modest understanding of how linux software RAID works, it
> seems I should be able to take an existing partition containing data
> (in this case sdb4 mounted as /mail) and build a RAID 1 array with
> something similar to this:
>=20
> umount /dev/sdb4
> mdadm --build /dev/md0 --level=3D1 -n2 /dev/sdb4 missing
> mount /dev/md0 /mail
> mdadm --add /dev/md0 /dev/sda4
>=20
> Will that work?  Or am I misunderstanding something fundamental?

It'll work but you'll be using a legacy array without superblocks, so=20
you can't have various features that come with superblocks like being=20
recognisable or having a write-intent bitmap, which is why most guides=20
suggest you --create an array with a blank partition then copy the data=
=2E=20
The man page says of build mode:
   Build an array that doesn=E2=80=99t  have  per-device  superblocks.
   For  these  sorts  of  arrays,  mdadm  cannot differentiate
   between initial creation  and  subsequent  assembly  of  an
   array.   It also cannot perform any checks that appropriate
   components have been requested.  Because of this, the Build
   mode  should  only  be used together with a complete under-
   standing of what you are doing.

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
