From: Lucas Barbuto <lucas@qk.com.au>
Subject: Order of RAID creation in boot process
Date: Wed, 29 Jan 2003 18:49:54 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030129074954.GA30915@qk.com.au>
Reply-To: Lucas Barbuto <lucas@qk.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I'm still struggling with mounting my root file system as a software
RAID-1.  As Norman Schmidt has suggested, the problem occurs because the
RAID is not created when the kernel is ready to mount it's root
partition.

I have checked the boot logs using 'dmesg' on a server that I have
installed a boot+root software RAID-1 on previously.  I noticed in that
configuration that all the RAID devices are created before the root
partition is mounted.  On my new server, the messages indicating the
RAID construction are after the root partition is mounted.  The
difference?  Well the new machine has a Promise PDC 20276 controller
(which I've disabled for the time being) and the drivers required for
this controller compiled into the kernel.  Messages about the ataraid
devices appear before the mounting of the root file system, but the md
software device messages come after that point.

Can anyone explain the timing of the software RAID construction?  How
can I get it to happen _before_ the root partition needs to be mounted?
I can't see any other differences between the two setups.  It must have
something to do with the code for the Promise ATA RAID controller,
right?

Thanks in advance.

Regards,

Lucas
