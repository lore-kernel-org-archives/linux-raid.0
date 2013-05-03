From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 03 May 2013 12:38:47 +0100
Message-ID: <5183A1C7.5000905@mpstor.com>
References: <51839E4F.7050102@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51839E4F.7050102@midgaard.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andreas Boman <aboman@midgaard.us>
List-Id: linux-raid.ids

On 03/05/13 12:23, Andreas Boman wrote:
> I have (had?) a raid 5 array, with 5 disks (1.5TB/EA), smartd warned 
> one was getting bad, so I replaced it with an identical disk.
> I issued mdadm --manage --add /dev/md127 /dev/sdX
>
> The array seemed to be rebuilding, was at around 15% when I went to bed.
>
> This morning I came up to see the array degraded with two missing 
> drives, another failed during the rebuild.
>
> I powered the system down, and since I have the disk smartd flagged as 
> bad and tried to just plug that in and power up hoping to see the 
> array come back up -no such luck (not enough disks).
>
Unfortunately this happens way too often: Your RAID members silently 
fail over time. They will get some bad blocks, and you won't know about 
it until you try to read or write one of the bad blocks. When that 
happen a disk will get kicked out. At this stage you'll replace the 
disk, not knowing that other areas of the other RAID members have also 
failed. The only sensible option is to run a RAID 6 which dramatically 
reduces the potential for double failure, or to run a RAID 5 but run a 
weekly (at least) check of the entire array for badblocks, carefully 
monitoring the smart reported changes after running the test (trying to 
read the entire array will cause badblocks to be detected and 
reallocated if any).
> I powered the system down again, and now I'm trying to evaluate my 
> best options to recover. Hoping to have some good advice in my inbox 
> when I get back from the office. I'll be able to boot the thing up and 
> get log info this afternoon.
>
I had to recover an array like that twice. The most important is 
probably to mitigate the data loss on the second drive that is failing 
right now by "ddrescueing" all of its data on another drive before it 
gets more damaged (the longer the failing drive is online the less 
chance you have). Use GNU ddrescue for that purpose.

Once you have rescued the failing drive onto a new one, you could then 
try to add that new recovered drive in place of the failing one and 
start the resync as you did before.

Note that it would probably be worthwhile to ddrescue the initial drive 
that you took out (if it is still good enough to do so) in case the 
second drive cannot be recovered correctly or is missing some data.

Regards,
Ben.

> Thanks!
> Andreas
>
> (please cc me, not subscribed)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

