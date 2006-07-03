From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID 5 crash, is there any way to recover some data ?
Date: Mon, 03 Jul 2006 11:46:15 -0700
Message-ID: <44A965F7.10401@h3c.com>
References: <44A95478.2050004@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A95478.2050004@online.no>
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quack@online.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sevrin Robstad wrote:
> I *had* a RAID 5 consisting of 6 x 200GB drives. After a power failure,
> my motherboard failed and I replaced it with some old crap I had.
> After some lockups on this platform I suddenly had more than one disk
> marked as bad.
> 
> And then, after some googling around - I tried "mdadm --assemble
> --force" ... It seemed fine when rebuilding, but after some time the
> hardware failed again..
> Now my raid was GONE.
> 
> I have tried some "mdadm --build" things, but I cannot get any data out
> of it, it stops on "no Ext3 filesystem found" ...
> 
> Is there *any* way for me to recover at least some of the data ?


I feel your pain, I've been there.

What you want to do is determine which 5 drives out of your 6 drive
array have the most up-to-date data. You can do this by looking at the
output of mdadm -E <partition> ('mdadm -E /dev/sda1' or similar) and
seeing which ones were updated most recently.

These 5 drives are now you're most important drives ever, to get your
data back.

The trick is to actually create an entirely new array, using those five
drives in the same order they were in your previous array, with the
keyword 'missing' in place of where ever the sixth drive would go.

This will create an array that won't re-sync since it's missing a drive
and can't make parity, right? But the layout will be the exact same as
your old array, so when you start it, the old data should be there, and
you should be able to run a fsck on your filesystem and make sure your
data is there.

At this point, you should back everything up if you haven't already :-)

Finally, add your sixth drive to the array so it will fill the missing
slot, and you'll have redundancy again.

For example, a command that would work for create would be:

mdadm --create -l 5 -n 6 /dev/md3 /dev/sda1 /dev/sdb1 /dev/sdc1 \
	missing /dev/sde1 /dev/sdf1

It seems scary since you are creating a new array, but with that missing
slot, all you're doing is creating new superblocks, so it's fairly safe.

-Mike

