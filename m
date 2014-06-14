From: "ptschack ." <ptschack@googlemail.com>
Subject: Re: Help with corrupted MDADM Raid6
Date: Sat, 14 Jun 2014 19:14:33 +0200
Message-ID: <CAH4F3Sb78S6mf-SRdNg-efiMUFHJvZ+Qc0uuTNsRWW4VNqyu2A@mail.gmail.com>
References: <CAH4F3SZ4Q8MO5Ci8ihSrLf1myo8pTfJ8SNC5EwJZQHf_H44GPA@mail.gmail.com>
	<20140613202541.584dc8f1@notabene.brown>
	<CAH4F3SZm-Va4a-2ac0E-_GHde0Vcqgrw0xs0GPn+hBkTjnsL9Q@mail.gmail.com>
	<20140614203146.5e99a84f@notabene.brown>
	<CAH4F3SYerAqXZ_un-vytvTyAJh+NMA5it3R4_gbgOsjLB8GvAA@mail.gmail.com>
	<20140614220618.5fcd36b5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140614220618.5fcd36b5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

you are a lifesaver, it worked! The RAID is currently rebuilding and
the data is all there, phew!
In the future I will always keep copies of the superblocks backed up :-P

Send me your PayPal address if you want me to buy you a beer :)

Greetings,
-P.

On Sat, Jun 14, 2014 at 2:06 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 14 Jun 2014 13:19:57 +0200 "ptschack ." <ptschack@googlemail.com>
> wrote:
>
>> Hi Neil,
>>
>> regrettably, I do not have logs from Jun 9th. This is what happened, in Detail:
>>
>> Before I grew the RAID, I made a backup of the system drive (Sometime
>> around the beginning of may). Then I grew the RAID and the dm-crypt
>> container on it.
>> I then noticed that ext4 filesystems cannot be grown above a certain
>> limit, which is why I decided to convert to BTRFS.
>> Prior to Jun 9th I upgraded Ubuntu from 12.04 LTS to 14.04 LTS. The
>> reason was that I wanted the newest BTRFS utils for the conversion.
>> The conversion went smoothly, but the Ubuntu upgrade messed with some
>> services running on the server (e.g. various configs for web apps,
>> nothing to do with the raid). So I wanted to do a fresh install. I
>> didn't do a backup of the system, because I had the old backup which
>> had worked before.
>>
>> I attempted the fresh install, looking at the disks with GParted
>> beforehand (as I said earlier, my theory is that GParted might have
>> messed up some of the md superblocks).
>> So after the fresh install, I wasn't able to start the RAID (error
>> message was input/output error).
>> So I thought I'll just restore the old backup, since that worked
>> perfectly, and then make my way from there.
>>
>> After the restore, The system asked me if I wanted to start a degraded
>> RAID. I thought it meant the raid was degraded because of the failing
>> drive, and said yes.
>> It then showed me a Raid with 6 Drives, all spares. At this point the
>> panic started to set in :(
>>
>> I have attached some log excerpts from the beginning of may, before I
>> made the backup and the old RAID was functioning (kern.log and syslog,
>> grepped for 'md').
>>
>> Furthermore, searching for the superblock with od gave me the following:
>>
>> od -x /dev/sdh | grep '4efc a92b'
>>
>> 20234525260 8a2a c251 a28b 2f92 f63e 8d72 4efc a92b
>> 103362752200 4efc a92b 3412 ad92 b451 bc40 5897 d215
>>
>> od -x /dev/sdi | grep '4efc a92b'
>>
>> 135674640060 4efc a92b 89de a9d8 d2b8 395e 6f37 4597
>>
>> I don't think those are the superblocks, but rather the "magic number"
>> being present somewhere on the drive :(
>
> Yes, I think you are correct.
>
>>
>> Doing further research I found this:
>> http://kevin.deldycke.com/2007/03/how-to-recover-a-raid-array-after-having-zero-ized-superblocks/
>>
>> Is there any "safe" way to restore the superblocks, or is re-creating
>> the RAID my final option?
>
> It looks like the only option left is to create the array again.
> Providing you use --assume-clean and don't add spares, this is fairly safe
> and you can try it again if you get it wrong.
>
> It might be good to use 'dd' to backup the first few megabytes of each drive
> just to be safe:  "mdadm --create" will only overwrite the metadata which is
> in the first few K, so maybe that is enough, but more doesn't hurt.
>
> Based on the logs use attached (which did have useful "bind" and
> "operational as" lines) the order should be:
>
> sda sdb sdc sdd sde sdf sdi sdh sdg
>
> So something like
>  mdadm -C /dev/md0 -l6 -n9 -c 64 --assume-clean \
>    --data-offset=262144s /dev/sd{a,b,c,d,e,f,i,h} missing
>
> Then try 'fsck -n' or similar.  If that looks good, try
>   echo check > /sys/block/md0/md/sync_action
> and when that finished, check that "mismatch_cnt" is small.
>
> If it is all good you should be safe to add another device and  let it
> rebuild.
>
> Then you can add a bitmap (--grow --bitmap=internal).  I wouldn't add the
> bitmap until the array seems to be otherwise OK.
>
> If the filesystem appears to be badly corrupted, you should stop the array,
> and possibly try a different order of devices.
>
> NeilBrown
