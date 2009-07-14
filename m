From: berk walker <berk@panix.com>
Subject: Re: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 07:13:08 -0400
Message-ID: <4A5C6844.903@panix.com>
References: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com> <4A5C588D.4000400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A5C588D.4000400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Ben Beuchler <insyte@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson wrote:
> On 14/07/2009 08:16, Ben Beuchler wrote:
>> I'd like to convert an existing partition to RAID 1 using a portion =
of
>> a new, blank drive.  All of the examples I've seen involve creating
>> the RAID device with the *empty* partition (sda4), copying the data
>> from the old partition to the new RAID, then adding the old partitio=
n
>> to the RAID set.
>>
>>> From my modest understanding of how linux software RAID works, it
>> seems I should be able to take an existing partition containing data
>> (in this case sdb4 mounted as /mail) and build a RAID 1 array with
>> something similar to this:
>>
>> umount /dev/sdb4
>> mdadm --build /dev/md0 --level=3D1 -n2 /dev/sdb4 missing
>> mount /dev/md0 /mail
>> mdadm --add /dev/md0 /dev/sda4
>>
>> Will that work?  Or am I misunderstanding something fundamental?
>
> It'll work but you'll be using a legacy array without superblocks, so=
=20
> you can't have various features that come with superblocks like being=
=20
> recognisable or having a write-intent bitmap, which is why most guide=
s=20
> suggest you --create an array with a blank partition then copy the=20
> data. The man page says of build mode:
>   Build an array that doesn=E2=80=99t  have  per-device  superblocks.
>   For  these  sorts  of  arrays,  mdadm  cannot differentiate
>   between initial creation  and  subsequent  assembly  of  an
>   array.   It also cannot perform any checks that appropriate
>   components have been requested.  Because of this, the Build
>   mode  should  only  be used together with a complete under-
>   standing of what you are doing.
>
> Cheers,
>
> John.
> .
I think that after a --create, missing on the new drive, you would want=
=20
to copy the contents of the original drive ,. Then add the original to=20
the raid..
berk


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
