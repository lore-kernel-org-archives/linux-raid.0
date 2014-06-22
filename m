From: George Duffield <forumscollective@gmail.com>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Sun, 22 Jun 2014 16:32:31 +0200
Message-ID: <CAG__1a4kX1gM+ntmcLkevCm6kwVbgSMGmPi-ec6+b1RGKznouw@mail.gmail.com>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
	<CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
	<CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
	<20140618150326.GA28569@cthulhu.home.robinhill.me.uk>
	<CAG__1a7m2BakDGUtP==YunzmBr8WDXVVv4i2WE=sYhBNKYjM1w@mail.gmail.com>
	<CAG__1a7zGbxzkR_a2ci4rw3xacxGYt07aBiAsFjGPYowXBPCcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a7zGbxzkR_a2ci4rw3xacxGYt07aBiAsFjGPYowXBPCcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Can anyone give me some hints as to why this array would remain Active
rather than report Clean?  Any help/ insights much appreciated.

On Wed, Jun 18, 2014 at 6:04 PM, George Duffield
<forumscollective@gmail.com> wrote:
> # cat /sys/block/md0/md/safe_mode_delay returns:
>
> 0.203
>
> changing the value to 0.500:
> # echo 0.503 > /sys/block/md0/md/safe_mode_delay
>
> makes no difference to the array state.
>
>
>
> On Wed, Jun 18, 2014 at 5:57 PM, George Duffield
> <forumscollective@gmail.com> wrote:
>> Thx Robin
>>
>> I've run:
>> # mdadm --manage /dev/md0 --re-add /dev/sdb1
>> mdadm: re-added /dev/sdb1
>>
>> # mdadm --detail /dev/md0 now returns:
>>
>> /dev/md0:
>>         Version : 1.2
>>   Creation Time : Thu Apr 17 01:13:52 2014
>>      Raid Level : raid5
>>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>>   Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
>>    Raid Devices : 5
>>   Total Devices : 5
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Wed Jun 18 19:46:38 2014
>>           State : active
>>  Active Devices : 5
>> Working Devices : 5
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>            Name : audioliboffsite:0  (local to host audioliboffsite)
>>            UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
>>          Events : 11319
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       17        0      active sync   /dev/sdb1
>>        1       8       65        1      active sync   /dev/sde1
>>        2       8       81        2      active sync   /dev/sdf1
>>        3       8       33        3      active sync   /dev/sdc1
>>        5       8       49        4      active sync   /dev/sdd1
>>
>>
>> # watch cat /proc/mdstat returns:
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdb1[0] sdd1[5] sdc1[3] sde1[1] sdf1[2]
>>       11720536064 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [5/5] [UUUUU]
>>       bitmap: 0/22 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>>
>> # watch -d 'grep md0 /proc/diskstats' returns:
>>    9       0 md0 348 0 2784 0 0 0 0 0 0 0 0
>>
>> and the output never changes.
>>
>> So, array seems OK, and I'm back to the question that started this
>> thread - why would this array's state be Active rather than Clean?
>>
>>
>>
>>
>> On Wed, Jun 18, 2014 at 5:03 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>>> On Wed Jun 18, 2014 at 03:25:27PM +0200, George Duffield wrote:
>>>
>>>> A little more information if it helps deciding on the best recovery
>>>> strategy.  As can be seen all drives still in the array have event
>>>> count:
>>>> Events : 11314
>>>>
>>>> The drive that fell out of the array has an event count of:
>>>> Events : 11306
>>>>
>>>> Unless mdadm writes to the drives when a machine is booted or the
>>>> array partitioned I know for certain that the array has not been
>>>> written to i.e. no files have been added or deleted.
>>>>
>>>> Per https://raid.wiki.kernel.org/index.php/RAID_Recovery it would seem
>>>> to me the following guidance applies:
>>>> If the event count closely matches but not exactly, use "mdadm
>>>> --assemble --force /dev/mdX <list of devices>" to force mdadm to
>>>> assemble the array anyway using the devices with the closest possible
>>>> event count. If the event count of a drive is way off, this probably
>>>> means that drive has been out of the array for a long time and
>>>> shouldn't be included in the assembly. Re-add it after the assembly so
>>>> it's sync:ed up using information from the drives with closest event
>>>> counts.
>>>>
>>>> However, in my case the array has been auto assebled by mdadm at boot
>>>> time.  How would I best go about adding /dev/sdb1 back into the array?
>>>>
>>> That doesn't matter here - a force assemble would have left out the
>>> drive with the lower event count as well. As there's a bitmap on the
>>> array then either a --re-add or a --add (these should be treated the
>>> same for arrays with persistent superblocks) should just synch any
>>> differences since the disk was failed.
