From: Lucas Barbuto <lucas@qk.com.au>
Subject: Re: Problems mounting root file system with software RAID-1
Date: Wed, 29 Jan 2003 10:13:59 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030128231359.GC26920@qk.com.au>
References: <20030128013036.GA22180@qk.com.au> <3E363B5B.5000105@ratnet.stw.uni-erlangen.de>
Reply-To: Lucas Barbuto <lucas@qk.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E363B5B.5000105@ratnet.stw.uni-erlangen.de>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Norman,

On Tue, Jan 28, 2003 at 09:12:11AM +0100, Norman Schmidt wrote:
> The kernel booting from a /boot md device doesn?t really boot off 
> /dev/md1 but off one of the bootblocks of /dev/hde and /dev/hdg (which 
> is perfectly good). The kernel doesn?t need /dev/md1 (=/boot) to boot, 
> but only one of the bootblocks to find the kernel image, which is 
> possible on both hde and hdg. The kernel panic occurs as soon as the 
> kernel wants to mount the / filesystem the first time. The reason for 
> this is that at that point, the raid devices (i.e. at least /dev/md2, 
> the others can be assembled later) are not assembled yet.

Ah!  This makes sense!

> You have two options: The older one is to make the underlying partitions 
> of /dev/md1 (you didn?t give their name) autodetectable (change 
> partition type to fd).

Yep, I did this.  The underlying partitions for md1 were hde1 and hdg1,
their types were 0xfd.  Same goes for md2 (the root partition).
Actually all the partitions on the system disks were set to 0xfd.

> The newer option is to tell the kernel at boot time how to assemble the 
> needed devices, which you do by inserting the following into the "image" 
> section of your booting kernel in /etc/lilo.conf:
> append = "md=2,/dev/hde3,/dev/hdg3"
> Change the partitions to those that build up /dev/md2.
> The kernel then can assemble its raid, since you compiled at least raid1 
> into it.

I'll give this a try.

> By the way: The most importatnt thing missing in your mail is 
> /etc/raidtab or /etc/mdadm/mdadm.conf.

I'll be sure to include this next time.

Thanks for your help.

Regards,

Lucas
