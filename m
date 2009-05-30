From: Neil Brown <neilb@suse.de>
Subject: Re: RAID-5 spare drive: Can't make spare persist across reboot
Date: Sun, 31 May 2009 07:53:50 +1000
Message-ID: <18977.43758.674932.381022@notabene.brown>
References: <984c80610905301137l7649391fg64a8108769abd216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Rea on Saturday May 30
Sender: linux-raid-owner@vger.kernel.org
To: David Rea <dave@daverea.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 30, dave@daverea.com wrote:
>    [First-time poster, done plenty of googling and archive searching
> before sending this, so if it's already been covered my apologies in
> advance...]
> 
> Hello All-
> 
> I am running a 3-disk RAID-5 using kernel 2.6.24 and mdadm 2.6.3 under
> Ubuntu server 8.04LTS. I'm trying to add a spare drive to the array.
> 
> /dev/md0 == /dev/sdc, /dev/sdd, /dev/sda
> 
> I want to add /dev/sdb1 as a spare partition, so I tried `mdadm
> /dev/md0 --add /dev/sdb1` ... this worked great; running `mdadm
> --detail /dev/md0` shows 3 active and 1 spare. Cool!
> 
> However, after a reboot, I'm back to 3 active and 0 spare drives. I
> tried adding the spare to my DEVICES list in /etc/mdadm/mdadm.conf,
> and adding a SPARES=1 attribute to the ARRAY line in that file, still
> no persistence. I tried running `update-initramfs -u` after changing
> mdadm.conf (per an IRC suggestion) but still no persistence.

This should "just work".  There might be some hints in
/var/log/messages if you'd like to post that.

> 
> -- Is it possible to do what I'm trying to do?

Definitely.

> -- Do I need to create the array anew using `mdadm --create` and
> specifying "--spare-devices=1 /dev/sdb1" during creation?

No.

> -- Will creating the array again risk corrupting the data already present?

There is always a risk - you might type the wrong command by mistake.  
Other than that there is no risk.
However doing so won't gain you anything.

> -- Is there any way to instantiate a superblock on /dev/sdb1 so that
> it can be associated with this array's UUID?

You have already done that.  Use
   mdadm --examine /dev/sdb
to confirm.

> -- I have the ARRAY line (in mdadm.conf) specified by UUID; could this
> be causing the spare to be excluded, since it (presumably) does not
> have a superblock?

No.  And it does have a superblock.

NeilBrown
