From: matt brennan <raid@classforge.com>
Subject: Re: Resizing raid-1 on replacing failed disk
Date: Sat, 23 Oct 2004 16:01:59 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4179FADF.40806@classforge.com>
References: <200410230541.i9N5fuN10579@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410230541.i9N5fuN10579@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote <snipped together from serveral replies>:

> You will be replacing your boot disk (I think).  This will be a grub
> or lilo issue.  

Thanks for your help! The array is not a boot disk (my bad - should have
clarified)...

> But I do have other notes: 
> * logically remove the failed disk - "mdadm /dev/md0 -r /dev/hdc1"
> * fail the smaller disk - "mdadm /dev/md0 -f /dev/hda1"
> * wait a few seconds (was some issue with failing and removing too quickly)
> * remove the smaller disk - "mdadm /dev/md0 -r /dev/hda1"

Thank you for this extra detail!

> If you're partition is ext2 or ext3, you can use resize2fs. A word of
> caution for you. I've used this utility many times, and it is
> necessary to do a e2fsck -f on the partition to be resized BOTH
> before and after.

And thanks again - this surely will help! It would perhaps be handy to 
have a tip on this (or more generally the resize array process) in the 
software-raid-faq (noting that e2fsck stuff is a file system rather than 
md issue). Perhaps I can contribute after completion.

> Please wait for someone to help with this!  But not
> me!  I don't trust my advice!  Other than my advice to wait for help.
> :)

Could someone else please comment on the overall feasibility of resizing 
a raid-1 array to physically larger disks via this process?

> - backup
> * logically remove the failed disk - "mdadm /dev/md0 -r /dev/hdc1"
> - physically remove the failed disk
> - physically replace the failed disk with a larger disk
> - add the new disk to the array and allow to resync
> * fail the smaller disk - "mdadm /dev/md0 -f /dev/hda1"
> * wait a few seconds (was some issue with failing and removing too quickly)
> * remove the smaller disk - "mdadm /dev/md0 -r /dev/hda1"
> - physically replace the active smaller disk with a larger disk
 > ** e2fsck -f
> - resize the ext3 partition
> ** e2fsck -f

Thanks and regards,

   matt



