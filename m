From: Franc Carter <franc@mml.usyd.edu.au>
Subject: Re: RAID as backup ...
Date: Sat, 21 Sep 2002 12:07:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200209211207.55097.franc@tech.sirca.org.au>
References: <Pine.LNX.3.96.1020920135652.11583A-100000@Maggie.Linux-Consulting.com>
Reply-To: Franc Carter <franc@mml.usyd.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1020920135652.11583A-100000@Maggie.Linux-Consulting.com>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>, "C.Lee Taylor" <leet@leenx.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Only partially relevant, but . . .

We have just set up ide raid5 set which we rsync our critical
servers to each night, in a weekly rotation. As there is a bit
of distance between the rsync server and the raid5 machine we
effectively have a very cheap warm offsite backup.

It saved our bacon just recently.

On Sat, 21 Sep 2002 07:01, Alvin Oga wrote:
> hi ya lee
> 
> - like the idea of using ide disks to backup other ide disks..
> 
> - i would NOT use raid1 ( mirroring ) for backup data
> 	- i would rather have 2 backup servers with 2 sets of backup disks
> 	than one backup server w/ mirror disks
> 
> - backup disks should be offline and unmountable except during the backup
>  process
> 
> - if you use raid1, and take one disk and hide it, your backup is
>   basically rendered dead(no longer raid) till you put that disk back in
>   again to backup more data to the "raid1" backup system
> 	- just use the one disk in that same removable tray and
> 	you are more likely to have a suitable/usable backup system
> 
> - always have different backup disks for daily backup, weekly backups
>   monthly backups and full backups... never use the same disks for it all
> 	( lose that disk, and you lose everything )
> 
> http://www.Linux-Backup.net
> 	- free backup scripts
> 	- 8x 120GB ide disks in one 1U chassis --> lots of fun(pain)
> 
> c ya
> alvin
> 
> > 	I intend to use RAID IDE to replace old, slow and problematic tape 
backup.
> > 
> > 	This is just theory at the moment, and I would like you to help punch 
wholes 
> > in my idea ...
> > 
> > 	Using normal IDE drives (3), USB 2.0 and an external housing and 5.25" 
> > mobile racks (2), I am playing with creating a RAID 1 setup.
> > 
> > 	If I remove one of the IDE drives from my RAID system.  Could I put it 
way 
> > in a safe and use it as a backup?
> > 
> > Mailed
> > Lee
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Franc Carter     Ph:61-2-8374-5071      Fax: 61-2-8374-5070
Systems Manager, SIRCA Ltd              http://www.sirca.org.au/

DISCLAIMER: The contents of this email, inclusive of attachments, may
be legally privileged and confidential. Any unauthorised use of the
contents is expressly prohibited. If you have received this message in
error or are not the intended recipient, you should destroy the email
message along with any attachment(s).  Unintended recipients of this
email are prohibited from retaining, disclosing, distributing or using
any information contained herein.  This email is also subject to
copyright. No part of it should be reproduced, adapted or transmitted
without the written consent of the copyright owner.

