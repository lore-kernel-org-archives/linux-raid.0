From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Howto avoid full re-sync
Date: Mon, 10 Sep 2012 09:11:54 +1000
Message-ID: <504D223A.6020707@websitemanagers.com.au>
References: <50497AE6.2010005@websitemanagers.com.au> <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/07/2012 07:41 PM, Ralf M=FCller wrote:
> Am 07.09.2012 um 06:41 schrieb Adam Goryachev:
>
>> I have a MD raid6 with 5 drives, and every now and then one (random)
>> drive will fail. I've done all sorts of checks, and the drive is
>> actually working fine, so I suspect an issue with the Linux driver
>> and/or SATA controller (onboard).
>>
>> It isn't really relevant to the question, but I'll run through the s=
ata
>> stuff, in case anyone can point out a simple solution to stop this f=
rom
>> happening (yes, a new server is on the way, but with budgets etc, th=
at
>> could be some time away. This issue has happened for years, but we a=
re
>> becoming more active with these failures now).
>>
>> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controlle=
r
>> (rev a1)
>> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controlle=
r
>> (rev a1)
>> 01:07.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA =
SATA
>> HostRAID Controller (rev 02)
>>
>> cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md2 : active raid6 sdh1[5] sdg1[4] sdf1[0] sdd1[6](F) sde1[2] sda1[1=
]
>>       5860535808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U=
]
>>       [>....................]  recovery =3D  1.4% (28663240/19535119=
36)
>> finish=3D486.5min speed=3D65938K/sec
>>
>>
>>
>> Since I know sdh is actually almost up to date, is there some way to
>> re-add it, and only have to sync the portions of the disk which have
>> changed?
>
> Besides all the stuff about fix your server, a raid is not a backup a=
nd you risk your data - simply add a write intent bitmap:
>
> # mdadm /dev/md2 --grow bitmap=3Dinternal
>
mdadm /dev/md2 --grow bitmap=3Dinternal
mdadm: can only add devices to linear arrays

md2 is raid6:
md2 : active raid6 sdh1[3] sdg1[4] sdf1[0] sde1[2] sda1[1]
       5860535808 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]

Regards,
Adam

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
