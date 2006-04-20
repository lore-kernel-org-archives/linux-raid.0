From: "Karl Schricker" <k_schricker@gmx.net>
Subject: Re: Raid5 says it's rebuilding, but it lies :)
Date: Thu, 20 Apr 2006 06:37:13 +0200 (MEST)
Message-ID: <22111.1145507833@www068.gmx.net>
References: <44463EAF.7000901@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> All the command line tricks in the world will not change the fact that
> his IEEE1394 drive subsystem is presenting one or more of his drives as
> read only devices..

Well, this turns out to have been true.  The IEEE1394 package I installed
included an eth1394 kernel module, which seems to have caused the conflict. 
Don't know why.  I disabled that thing, and all of a sudden the errors
stopped and the array came right back up.

Unfortunately, there must've been some data loss:

# fsck /dev/md0
fsck 1.38 (30-Jun-2005)
fsck.jfs version 1.1.7, 22-Jul-2004
processing started: 4/19/2006 21.35.4
Using default parameter: -p
The current device is:  /dev/md0
Block size in bytes:  4096
Filesystem size in blocks:  183148848
**Phase 0 - Replay Journal Log
Warning... fsck.jfs for device /dev/md0 exited with signal 11.
# mount -a
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Any ideas on where to take it from here?

Thanks,


Karl

-- 
Echte DSL-Flatrate dauerhaft für 0,- Euro*!
"Feel free" mit GMX DSL! http://www.gmx.net/de/go/dsl
