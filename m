From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 14:47:30 -0600
Message-ID: <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
References: <5796B46B.6060905@suddenlinkmail.com> <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au> <5797C415.8010206@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797C415.8010206@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 26, 2016 at 2:12 PM, David C. Rankin
<drankinatty@suddenlinkmail.com> wrote:
> On 07/26/2016 04:52 AM, Adam Goryachev wrote:
>> No, I'm saying that is an excellent idea, and it is exactly what I always do.
>> The problem is that you created the single large primary partition, and then
>> used the raw drive for the raid array instead of using the partition.
>
> Damn, that is exactly what I did, even though I intended to use sdc1 and sdd1.
> Checking bash_history for root, I find:
>
> mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 /dev/md4
> /dev/sdc /dev/sdd

When I try this, mdadm complains:

[root@f24s ~]# !994
mdadm -C /dev/md0 -n 2 -l raid1 /dev/VG/1 /dev/VG/2
mdadm: /dev/VG/1 appears to be part of a raid array:
       level=raid0 devices=0 ctime=Wed Dec 31 17:00:00 1969
mdadm: partition table exists on /dev/VG/1 but will be lost or
       meaningless after creating array
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? n
mdadm: create aborted.
[root@f24s ~]# rpm -q mdadm
mdadm-3.3.4-4.fc24.x86_64

OK and now I re-read the original post, and the table is also damaged.
What I think is happening is mdadm v1.2 metadata at 4K offset is
inside the area for table entries 5-128. So even though there are no
such entries, gdisk is seeing this unexpected data in areas that
should be zero'd. But nothing else has actually been stepped on.

But it doesn't matter because you're not using the partitions you've
created anyway. It's still a good idea to remove the signature from
the GPT and the PMBR (three signatures).


> So basically I just need to fix the partition table on sdc,

No just remove the GPT signatures, "45 46 49 20 50 41 52 54" and the
PMBR signature "55 aa" from the two drives.

Restoring the primary GPT on sdd overwrote part of the mdadm metadata.
I'm not sure if --readd alone will fix that, or if one of the
--update= options is necessary as well, and if so which one.


-- 
Chris Murphy
