From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm raid can't set proper devices in super-block
Date: Mon, 12 Mar 2012 18:33:15 +0000
Message-ID: <4F5E416B.9020003@anonymous.org.uk>
References: <loom.20120312T183628-941@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20120312T183628-941@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Engstrom <engstrom@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/2012 17:38, Carl Engstrom wrote:
> resetting mdadm superblock
>
> --------------------------------------------------------------------------------
>
> Hey folks,
>
> I'm having some issues with my md array after upgrading to 11.04.
[...]
> Number Major Minor RaidDevice State
>   this 1 8 17 1 active sync /dev/sdb1
>
> 0 0 8 1 0 active sync /dev/sda1
>   1 1 8 17 1 active sync /dev/sdb1
>   --------
>
> the array will start with:
>   mdadm -A --update=super-minor /dev/md0 /dev/sdb1 /dev/sdc1

So it starts just fine if you specify the devices...

> Anyone know what's going on?

--update=super-minor is working fine; both devices have a preferred 
minor device number of zero, as they should for the array to be /dev/md0.

What happens if you
   mdadm --stop /dev/md0
   mdadm --assemble --scan --verbose /dev/md0
?

Where do you want to mount /dev/md0?

What messages do you get during boot-up (dmesg) about why md0 isn't 
being assembled?

What's in your /etc/mdadm.conf?

If /etc/mdadm.conf says sda1 and sdb1, fix it and do whatever you need 
to do on Ubuntu to rebuild your initrd/initramfs (so that your edited 
mdadm.conf goes into it), then reboot.

Hope something somewhere in amongst this lot helps...

Cheers,

John.

