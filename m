From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Strange RAID behaviour when faced with user error
Date: Wed, 10 Jun 2009 23:19:36 +0100
Message-ID: <4A303178.5060208@anonymous.org.uk>
References: <20090610215835.GA4936@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090610215835.GA4936@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2009 22:58, Jody McIntyre wrote:
> A user actually ran into this in the field (RHEL 5.3) and I'm able to reproduce
> with:
> Linux vm1 2.6.30-rc8 #1 SMP Mon Jun 8 11:32:59 EDT 2009 x86_64 GNU/Linux
> mdadm - v2.6.7 - 6th June 2008
> 
> I'll investigate (i.e. read/debug code) when I have time but any insights would
> be apprecated.
> 
> 1. Assemble a RAID array incorrectly (forgetting the array name):
> 
> # mdadm --assemble /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4 --run
> mdadm: /dev/sdb1 has been started with 3 drives (out of 4).
> (The user did not require --run; I'm not sure why.)
> 
> 2. An array is actually started.  That's not so weird...
> 
> # cat /proc/mdstat
> Personalities : [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
> md127 : active raid10 sdb2[1] sdb4[3] sdb3[2]
>       513792 blocks 64K chunks 2 near-copies [4/3] [_UUU]
>       
> unused devices: <none>
> 
> 3. But:
> 
> # mdadm --examine /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
> # mdadm --stop /dev/sdb1
> mdadm: stopped /dev/sdb1
> # mdadm --examine /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
> # mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
> mdadm: no recogniseable superblock on /dev/sdb1
> mdadm: /dev/sdb1 has no superblock - assembly aborted
> 
> 
> The problem goes away after a reboot.

The device node /dev/sdb1 was turned into a md one - probably 9,127 - 
when you started the array, and stopping the array hasn't reverted it. 
mknod /dev/sdb1 8 17 would probably have fixed it. Assuming you're using 
udev, the /dev/sdb1 device is recreated the next time you reboot, so the 
problem goes away.

I think mdadm 3.0 would have deleted the device node when the array was 
stopped, but mdadm 2.6.x doesn't.

Cheers,

John.
