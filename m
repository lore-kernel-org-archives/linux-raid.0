From: Ben Beuchler <insyte@gmail.com>
Subject: Re: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 10:44:15 -0500
Message-ID: <479b70ed0907140844p16b0081fh28bb1386a28afb1a@mail.gmail.com>
References: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com>
	 <4A5C588D.4000400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A5C588D.4000400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> umount /dev/sdb4
>> mdadm --build /dev/md0 --level=3D1 -n2 /dev/sdb4 missing
>> mount /dev/md0 /mail
>> mdadm --add /dev/md0 /dev/sda4
>>
>> Will that work? =C2=A0Or am I misunderstanding something fundamental=
?
>
> It'll work but you'll be using a legacy array without superblocks, so=
 you
> can't have various features that come with superblocks

Right; for this particular application I'm willing to give up
superblocks.  Just to be 100% sure, thought:  the way I've described
the process would be non-destructive of the data on sdb4?

Thanks!

-Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
