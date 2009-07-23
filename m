From: Aldo Foot <lunixer@gmail.com>
Subject: Re: properly configure degraded array
Date: Thu, 23 Jul 2009 15:43:32 -0700
Message-ID: <3d22fc520907231543g7864ce85peddc597c977b273@mail.gmail.com>
References: <3d22fc520907231150m70f24365xcd0544f29a03bc12@mail.gmail.com>
	 <7f9b256f460f6a4b57505d0969480bcf.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f9b256f460f6a4b57505d0969480bcf.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 23, 2009 at 2:54 PM, NeilBrown<neilb@suse.de> wrote:
> On Fri, July 24, 2009 4:50 am, Aldo Foot wrote:
>> I have a raid setup from which I physically removed a hard drive.
>> The array has three good active physical devices.
>> The output from mdadm shows "Raid Devices : 4" and "Total Devices : =
3"
>> My objective is to removed all indications of the removed device. No=
te
>> that
>> the removed drive has no device name associated with it, so I cannot
>> remove it with mdadm.
>> Is it as simple as editing the /etc/mdadm.conf to "num-devices=3D3"?=
 Would
>> that change the "State : clean, degraded " to just clean?
>> Is there something else that needs to be done to do this correctly?
>>
>> Here's what the config looks like at the moment:
>>
>> # mdadm -D /dev/md0
>> /dev/md0:
>> =A0 =A0 =A0 =A0 Version : 0.90
>> =A0 Creation Time : Fri Jul 10 02:39:32 2009
>> =A0 =A0 =A0Raid Level : raid1
>> =A0 =A0 =A0Array Size : 24000 (23.44 MiB 24.58 MB)
>> =A0 Used Dev Size : 24000 (23.44 MiB 24.58 MB)
>> =A0 =A0Raid Devices : 4
>> =A0 Total Devices : 3
>> Preferred Minor : 0
>> =A0 =A0 Persistence : Superblock is persistent
>>
>> =A0 =A0 Update Time : Thu Jul 23 04:18:18 2009
>> =A0 =A0 =A0 =A0 =A0 State : clean, degraded
>> =A0Active Devices : 3
>> Working Devices : 3
>> =A0Failed Devices : 0
>> =A0 Spare Devices : 0
>>
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : fafe2b90:7ae3cb68:2011742e:3cbab095 (l=
ocal to host
>> xxxxxxxxxx)
>> =A0 =A0 =A0 =A0 =A0Events : 0.82
>>
>> =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
>> =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
>> =A0 =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 =A08 =A0 =A0 =A0 =A02 =A0=
 =A0 =A0 =A0active sync =A0 /dev/sda8
>> =A0 =A0 =A0 =A03 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0 removed
>>
>> # mdadm --detail --scan
>> ARRAY /dev/md0 level=3Draid1 num-devices=3D4 metadata=3D0.90
>> UUID=3Dfafe2b90:7ae3cb68:2011742e:3cbab095
>>
>> any thoughts appreciated,
>
> mdadm --grow /dev/md0 --raid-devices=3D3

_______

That worked! nothing better than clean, accurate advice.

# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[0] sda8[2] sdc1[1]
      24000 blocks [3/3] [UUU]

=46or the record, changing "num-devices=3D3" in /etc/mdadm.conf did not=
 work; the
array would not even start.

many thanks,
~af
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
