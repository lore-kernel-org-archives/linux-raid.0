From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: Odd --examine output
Date: Fri, 12 Apr 2013 16:47:53 +0000
Message-ID: <CD8DAF4D.412EF%michael.vanhorn@wright.edu>
References: <51681FB2.8060803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51681FB2.8060803@turmel.org>
Content-Language: en-US
Content-ID: <1DB39131E00EED49AD00B0E0B5AC2C1B@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/12/13 10:52 AM, "Phil Turmel" <philip@turmel.org> wrote:

[snip]

>As noted above, the partition tables aren't wiped.  Just the device
>nodes are missing.  You could try a "blockdev --rereadpt /dev/sdX" on
>affected drives to see if it is a transient issue.

That did it! I was able to run blockdev for all of the drives that had
missing devices for the partitions, and then was able to

 mdadm --assemble --force /dev/md0 /dev/sd[cdefghi]1

and it assembled using all of the disks except, for some reason, sde1 and
sdf1. I think sde1 got left out because it had been dropped before the
raid actually stopped, and I think I could have added it back in with

 mdadm /dev/md0 --re-add /dev/sde1

(since /dev/sde actually seems to be fine). However, once I got the
filesystem mounted, my first priority was to get the data off, so I didn't
try to re-add that disk.

I don't know why sdf1 got left out.
 
[snip]

>If the partition is *not* aligned, each large chunk written will have at
>least two R-M-W cycles.

I snipped most of that explanation, but thank you for it; it really helps
me understand what was going on with my partitions.

>I guess "lsdrv" didn't work for you.  I'm naturally curious how it
>failed....

I don't have an lsdrv command, so I did the 'ls -l' that you suggested.

>Anyways, your detailed smartctl reports show big problems:
>
>1)  You have multiple drives with many dozens of pending relocations.
>This suggests that your regular scrubs are not happening on schedule.  A
>"check" scrub turns pending relocations into either real relocations, or
>no error at all (successful rewrite).  Typically the latter.

I've got a raid-check script that runs from cron.weekly. I really did
think it was working, because every week I would check and the array was
re-building.

>2) All of your self-test log entries show "short offline".  That isn't
>rigorous enough.  You need "long offline" self-tests occasionally, too.
> Or just use the long self-test every time.

I will take this into account, and being using the long test.

>3) You have a drive that entirely failed its SMART assessment
>{WD-WMAUR0381532 ==> /dev/sdj} due to excessive actual relocations.
>Replace this drive immediately.

I will. I have a spare disk on the shelf ready to go, once I feel safe
that the data is copied.

[snip]

>NOT a guess.  Back up what you can, while you can, and start over.  Use
>"fdisk -u" so you can ensure partitions start on multiples of eight (8)
>sectors.  (Modern fdisk uses 1MB alignment by default.  Highly
>recommended.)

That is exactly what I'm going to do. I feel like an idiot that there
seems to have been so many things wrong and I didn't realize it. Now,
thanks to your help, and I am much more enlightened.

Thanks!

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




