From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: raid md126, md127 problem after reboot, howto fix?
Date: Mon, 09 Feb 2015 10:41:22 +0100
Message-ID: <54D880C2.4080501@profitbricks.com>
References: <54D7B317.5010809@gmail.com> <54D7D551.2030800@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D7D551.2030800@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Marc Widmer <metafor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08.02.2015 22:29, Wols Lists wrote:
> On 08/02/15 19:03, Marc Widmer wrote:
>> Hi List
>>
>> I have no deep unterstand about raids, beside setting them up initially and
>> replacing disks if needed. So this error has never happened to me before:
>>
>> After a reboot i have a really strange behaviour on my server. Disks are
>> not marked faulty, but raid is "fallend apart".
>>
>> /proc/mdstat shows me:
>>
>> md126 : active raid1 sda1[0]
>>       10485696 blocks [2/1] [U_]
>>
>> md127 : active raid1 sda2[0]
>>       721558464 blocks [2/1] [U_]
>>
>> md1 : active raid1 sdb1[1]
>>       10485696 blocks [2/1] [_U]
>>
>> md2 : active raid1 sdb2[1]
>>       721558464 blocks [2/1] [_U]
>>
>> wished would be something similar to:
>> md1 : active raid1 sdb1[1] sda1[0]
>>       10238912 blocks [2/2] [UU]
>>
>> md2 : active raid1 sdb2[1] sda2[0]
>>       1942746048 blocks [2/2] [UU]
>>
>> Currently only md1, md2 are running. nmon shows me, that only disks sdb is
>> active, sda is not doing anything.
>>
>> I run debian squeeze.
> 
> What version of mdadm are you running? 3.2.6 or thereabouts?
>>
>> I am a bit concerned what to do, because at the moment i run on one disk
>> only and if things go wrong i end up with a server not running (downtime)
>> and possible data loss (beside backups).
>>
>> Any ideas what i should do? Howto put the raid back together, possibly in
>> live mode, without rebooting in rescue mode and risk long downtime?
>>
>> Any help would be greatly appreciated as by now the only thing i had to do
>> was resyncing a disk after usual hd crash.
>>
> The reason I ask is this looks like a bug I had - if I'm right it's a
> known problem and you need to upgrade mdadm.

Yeah, pretty much sounds like the bad udev rules with Squeeze and old
mdadm. E.g. deactivation of the MD udev rules and assembling via init
scripts is a way to workaround this.

I have some test VMs providing MD RAID-1 on iSCSI targets and have seen
the same issue when logging in to the targets. Deactivation of the udev
rules and manual assembly helped.

Cheers,
Sebastian
