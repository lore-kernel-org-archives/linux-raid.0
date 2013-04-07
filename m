From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Help, array corrupted after clean shutdown.
Date: Sun, 07 Apr 2013 19:12:26 +0200
Message-ID: <5161A8FA.2080906@schinagl.nl>
References: <5160060B.8020603@schinagl.nl> <CACj=ugTsNd87z4Uq_KdZa_HJYFNTtxwZJ76bv0GNHUj8D66YTA@mail.gmail.com> <51603BF2.404@schinagl.nl> <CACj=ugSH2YBrePTKy3e36H4fcHpKQ8ywxrJoLJwbqtbvOR+pEQ@mail.gmail.com> <5160630D.9000508@schinagl.nl> <CACj=ugQR6hjw0qchJiOtgyWd8VRGs_pkZCBXHbQwjrKFz4u=Xg@mail.gmail.com> <51619195.9070507@schinagl.nl> <CACj=ugTozdbEKvzeNZ4ZjH67P2mqFAicj_SJM6Ui9pUT64oPeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACj=ugTozdbEKvzeNZ4ZjH67P2mqFAicj_SJM6Ui9pUT64oPeg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08-04-13 10:10, Durval Menezes wrote:
> Hi Oliver.
>
> On Sun, Apr 7, 2013 at 12:32 PM, Oliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>> On 06-04-13 20:59, Durval Menezes wrote:
>>> Hi Oliver,
>>>
>>>
>>> On Sat, Apr 6, 2013 at 3:01 PM, Oliver Schinagl <oliver+list@schinagl.nl
>>> <mailto:oliver+list@schinagl.nl>> wrote:
>>>
>>>      On 04/06/13 19:44, Durval Menezes wrote:
>>>
>>>          Hi Oliver,
>>>
>>>          Seems most of your problems are filesystem corruption (the
>>>          extN family
>>>          is well known for lack of robustness).
>>>
>>>          I would try to mount the filesystem read-only (without fsck)
>>>          and copy
>>>          off as much data as possible... Then fsck and try to copy the
>>>          rest.
>>>
>>>          Good luck.
>>>
>>>      It fails to mount ;)
>>>
>>>      How can I ensure that the array is not corrupt however (while
>>>      degraded)? At least that way, I can try my luck with ext4 tools.
>>>
>>>
>>> If the array was not degraded, I would try an array check:
>>>
>>> |echo check > /sys/block/md0/md/sync_action|
>>>
>>> Then, if you had no (or very little) mismatches, I would consider it OK.
>>> But as your array is in degraded mode, you have no redundancy to enable you
>>> to check... :-/
>> I guess the 'order' wouldn't have mattered. I would have expected some
>> very basic check was available.
>>
>> Maybe for raid8 :p; Thinking along the lines, every block has an id, and
>> each stripe has maching id's. If the id's no longer match, something is
>> wrong. Would probably only waste space in the end.
> And time ;-)
>
>> Anyhow, I may have panicked a little to early. mount did indeed fail to
>> mount, checking dmesg revealed a little more:
>> [  117.665385] EXT4-fs (md102): mounted filesystem with writeback data
>> mode. Opts: commit=120,data=writeback
>> [  126.743000] EXT4-fs (md101): ext4_check_descriptors: Checksum for group
>> 0 failed (42475!=15853)
>> [  126.743003] EXT4-fs (md101): group descriptors corrupted!
>>
>> I asked on linux-ext4 what could be going wrong, fsck-ing -n does show
>> (all?) group-descriptors not matching.
> Ouch :-/
>
>> Mounting ro however works
> Glad to hear it. When you said that "it fails to mount", I thought you
> had tried mounting read-only as I suggested.
mount complained, like when you use an invalid filesystem. The error 
could have been more descriptive. I tried mounting RO after you 
mentioned it (and marking the array as read-only).
>
>> and all data appears to be correct from a quick
>> investigation (my virtual machines start normally, so if that is ok, the
>> rest must be too.
> So probably only ext4 allocation metadata (which I think is what the
> group descriptors are) got corrupted... probably your data survived
> OK.
Looks like, the disk reports an unhealthy amount of freespace. But every 
single group descriptor got corrupted. Starting from 0, 1 .. 32k (and 
then I ctrl-c-ed). It's odd to get corrupted in that way. Well the 
checksum didn't match. I'd rather think either the on-disk format 
changed since 2010 somewhat, or usertools work differently.

Side story mode, I have an android tablet with ext4 filesystem for 
/data. The tablet runs a 3.0 kernel. A few weeks ago, the tablet refused 
to boot. I booted from SD card into a stock GNU/Linux 3.4 enviroment and 
ran fdisk. Same thing, all group descriptors where corrupt (didn't 
match). fsck ran for 10 minutes and its still working fine.
>
>> I am now in the progress of copying, and rsycn -car the
>> data to a temporary spot.
> After your data is copied, try validating it with whatever tools
> available, for example: for compressed files, try checking them (ex:
> "tar tvzf" for tar.gz files); if it's your root partition, try
> checking your distribution packages (rpm -Va on RPM distros, for
> example), etc. If it shows any corrupted data, it might point you
> towards things that need restoring, and if it shows nothing wrong, it
> will give you confidence that the rest of your (uncheckable) data is
> possibly good too.
It does look that the data survived just fine. It is a pure data disk, 
but did contain some virtual machines. kvm runs them all fine at the moment.

While I could just fsck the fs and get it all good again, I have now all 
data from the device. I will use that to increase the chunksize from 256 
to 512k, and remake the fs with those new parameters. I'm sure fsck will 
most likly fix it and nothing will be wrong. I'm simply not willing to 
take the risk now that the disks are empty anyway.
>
>> Thanks for all the help though, I probably would
>> have kept trying to fix the array first.
> No prob, and good luck with the rest of your recovery!
Thank you ;)
>
>
>> I'm still wondering why my entire (and only the) partition table was gone.
> One theory: as your shutdown was clean, then ext4 allocation metadata
> has probably been badly mangled in memory before the shutdown, so some
> of your data was possibly written over the start of the disk,
> clobbering the GPT.
>
> Off (Linux md RAID) topic: If I were in your place, I would start
> worrying how the in-memory metadata was SILENTLY mangled in the first
> place... do you use ECC memory, for example? Also, I would consider
> (now that you will have to mkfs the mangled partition to restore your
> data anyway) using a filesystem that has multiple metadata copies and
> also the means for not only finding out about silent corruptions but
> also for fixing them, to say nothing of a built-in RAID with no
> write-hole and that gives your data the same silent-corruption
> detection-and-fixing feature: http://zfsonlinux.org/
>
> Cheers,

