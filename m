From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm -A erased the superblock ?
Date: Tue, 25 Mar 2008 16:09:24 +1100
Message-ID: <18408.35076.866095.278205@notabene.brown>
References: <40829.192.168.1.70.1206129490.squirrel@neil.brown.name>
	<4510.66972.qm@web32801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pradeep on Saturday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Pradeep <pradeepjp@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 22, pradeepjp@yahoo.com wrote:
> 
> > Where there any kernel message (view with 'dmesg') at this time?
> 
> Mar 21 00:27:45 brahma kernel: md: invalid raid superblock magic on sdd
> Mar 21 00:27:45 brahma kernel: md: sdd does not have a valid v0.90 superblock, not
> importing!
> Mar 21 00:27:45 brahma kernel: md: md_import_device returned -22
> 

So mdadm did try to assemble the array out of /dev/sdd.  I wonder why.

When it did that, it would have told the kernel to forget about all
the partitions on /dev/sdd so they didn't confuse things.  This is why
/dev/sdd1 etc seem to disappear.

> 
> 
>     What is much more interesting, is that I rebooted the machine, and 'mdadm --examine'
> started working again (producing output).
> I then retried the 'mdadm -A' command and that went through as well.

What do you mean exactly.  Did it assemble the array correctly?


> I cannot recall if the raid set was originally created on a 32 or a 64 bit O.S.

It shouldn't make any difference.

> 
> Is there any other diagnostic I can try ?

Not sure... If the array is working now, I don't think there is a need
to explore further.
If it isn't, maybe
  strace -o /tmp/strace mdadm -v -A ......

immediately after a reboot might help (Attach "/tmp/strace").

NeilBrown
