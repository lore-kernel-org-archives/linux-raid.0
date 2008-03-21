From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm -A erased the superblock ?
Date: Sat, 22 Mar 2008 06:58:10 +1100 (EST)
Message-ID: <40829.192.168.1.70.1206129490.squirrel@neil.brown.name>
References: <671934.68934.qm@web32802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <671934.68934.qm@web32802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pradeep <pradeepjp@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, March 21, 2008 7:26 am, Pradeep wrote:
> Hi,
>     It appears that a 'mdadm -A' command erased the superblocks on my
> disks.
> Could you please take a look and let me know if I did something wrong ?
>
> (I was adding 2 disks that were in a raid 1 set to a new machine running
> fedora 8.)
> Briefly, I issued an 'mdadm --examine /dev/sdd1' command to check the
> disks in my raid 1
> array.
> (repeat similar command for /dev/sde1)
>
> Then I issued 'mdadm -A -v -u '400f8c5f:045827ea:f72fe561:698ccea2'
> /dev/md0'
> which errored out because it was looking at /dev/sdd instead of /dev/sdd1
>

This isn't why it errored out.  It looked at sdd and found nothing there.
It also looked at various other devices and found nothing usable there.
That is perfectly normal.

What is strange is that it found sdd1 and sde1 in /proc/partitions,
but couldn't find names for them in /dev, so it reports them as
8:65 and 8:49

However when you ran the "--examine", it did find /dev/sdd1 in
/dev with the correct major/minor numbers.  So something must
have happened between those two commands.

Also, I cannot think why it is reporting "Invalid argument" and
failing to add the devices to the array.
Where there any kernel message (view with 'dmesg') at this time?

NeilBrown



