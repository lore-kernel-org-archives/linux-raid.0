From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Status of discard support in MD RAID
Date: Fri, 12 Sep 2014 17:26:31 +0800
Message-ID: <5412BC47.1000206@fnarfbargle.com>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com> <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com> <5412B6D7.1060400@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5412B6D7.1060400@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Chris Murphy <lists@colorremedies.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 12/09/14 17:03, David Brown wrote:
> On 12/09/14 02:46, Chris Murphy wrote:
>>
>> On Sep 11, 2014, at 5:38 PM, Brassow Jonathan <jbrassow@redhat.com>
>> wrote:
>>
>>> Neil (or anyone else),
>>>
>>> I know that trim/discard support was added back in 2012 (commit
>>> 9db90880).  However, I thought there were still issues regarding
>>> what happens when various sync operations occur.  I'd like to turn
>>> on discard support in dm-raid.c (a oneline patch) if things are in
>>> order.  I can enable any, all or none depending on your
>>> recommendation.  (I assume RAID1/10 is easier than the parity
>>> RAIDs.)
>>
>> If all the controller and drive support it then it should pass
>> through, but there's the problem whether the SSD supports
>> deterministic trim. If it doesn't, a check check > md/sync_action
>> will report mismatches in md/mismatch_cnt; and a repair will probably
>> corrupt the volume. So you can still use trim with a drive that
>> returns non-deterministic results with raid0/1/10, but you can't rely
>> on the result of md/mismatch_cnt and you can't do repair type
>> scrubs.
>>
>> For raid5/6, it's a problem to use trim if the drive returns
>> non-deterministically for trimmed blocks. I'd think that in addition
>> to DRAT being supported, it'd need to support DZAT.
>>
>> smartctl --identify=wb /dev/diskX | grep -i trim
>>
>>
>> Chris Murphy
>>
>
> Would it be possible to change trim/discard commands into write zero
> blocks for some SSDs?  A number of SSD controllers support transparent
> compression, so writing large batches of zeros will result in very small
> writes to the actual flash, and the SSD controller will be able to
> recycle flash used by the overwritten logical blocks just as if they
> were trimmed.  Obviously writing zeros will take longer in transfer than
> trim commands, but the result on the disk would be similar and it would
> be guaranteed deterministic.
>

I have 6 drives here. 3 Intel 330's and 3 Samsung 830's. The Intel 330s 
compress transparently (Sandforce controllers). They also support 
deterministic and return 0 on trimmed areas. The Samsungs don't compress 
and don't support deterministic or 0 on trimmed areas.

They are in a 6 drive RAID10 and I just put up with the massive mismatch 
count. Contrary to what Chris wrote, there is no damage caused by a 
repair type of scrub. Depending on the direction it either copies 0's to 
the Samsungs or random garbage to the Intels. It simply ends up writing 
to all the trimmed areas, so I don't do it.

Frankly if I considered this an issue I'd just go and replace the 
Samsungs with something newer, but as it has no practical ramifications 
in the real world I'll use them until I either run out of space or I 
wear them out.

I certainly don't believe it is worth of any form of special casing in 
the block, RAID or filesystem code. Just tell people that if they want 
to use SSD's in RAID and get properly working trim then all drives need 
to support return deterministic and return 0 on trim.

As it is, I get this once a month :System Events
=-=-=-=-=-=-=
Sep  7 02:12:49 srv mdadm[6341]: RebuildFinished event detected on md 
device /dev/md2, component device  mismatches found: 7100032 (on raid 
level 10)

The machine is on a serious UPS and gets rebooted about twice a year, so 
I'm not afraid of unclean shutdowns.

Regards,
Brad
