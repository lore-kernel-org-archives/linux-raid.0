From: "Danny Sung" <dsung@lantronix.com>
Subject: RE: Raid1 uses partially reconstructed drive
Date: Fri, 17 Nov 2006 10:01:13 -0800
Message-ID: <2F0FC2A92C0B154BB406D5E74CB3E6930336BDC9@3putt.int.lantronix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Uhh... I have no idea what metadata or bitmap anything I was using...
Default I guess?  How do I safely get that info?  I didn't see anything
obvious in the man page.

I think what may have happened is that I had created the primary drive
on hdb, then physically moved it to hda.

I wish I wrote the exact commands and sequence down, but I think I did
something like this:
 - hda: temporary     hdb: primary raid
   mdadm --create --level=1 --raid-devices=1 --force md0 /dev/hdb3
 - fill data into hdb3 (via network)
 - hda: primary raid  hdb: secondary raid
   reboot
 - mdadm --grow (??)   #  something to say it's now a 2-disk mirror, I
think
 - mdadm --add md0 /dev/hdb3     # adding the secondary into the raid
set
 - At this point, hdb3 is reconstructing
 - reboot
 - system uses hdb3 as primary?!?!


By "secondary" I mean the fresh disk I'm adding to the raid set. i.e.
not the one I should be booting off.

BTW, in addition to using FC5's kernel 2.6.18 (smp), I was also using
mdadm-2.3.1.

If it's not reproduceable, I guess I feel a bit better about it.... It
must mean I hit some sort of special case.


-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, November 16, 2006 9:24 PM
To: Danny Sung
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid1 uses partially reconstructed drive

On Wednesday November 15, dsung@lantronix.com wrote:
> Perhaps this is the problem addressed in the 2.6.18.2 patch... But I 
> thought I'd post it here just in case.
> 
> I was cloning some drives, and ended up creating a 1 drive RAID1
array.
> After that was built, I decided to add my spare drive and allow the 
> reconstruction to take care of things.  As soon as I saw that 
> reconstruction was taking place, I shutdown the system, put the drives

> away and closed the case.
> 
> To my surprise, when I booted, I encountered numerous disk errors.
> Apparently the system decided to ues the partially reconstructed drive

> as the primary!  And of course, it had no knowledge that 
> reconstruction needed to continue.  My data was hosed and I had to 
> restart the cloning process.

I've been trying to reproduce this and have failed.  Can you give me
some more details?
Where you using version 1 metadata or the default version 0.90 (though
/etc/mdadm.conf can override the default).
Were you using a write-intent bitmap?  If so, internal or external?

If you can come up with an exact sequence of actions to reproduce this
I'd really appreciate it, but I don't really expect it.

Thanks,
NeilBrown
**********************************************************************
This e-mail is the property of Lantronix. It is intended only for the person or entity to which it is addressed and may contain information that is privileged, confidential, or otherwise protected from disclosure. Distribution or copying of this e-mail, or the information contained herein, to anyone other than the intended recipient is prohibited.

