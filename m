From: "Gernot A. Weber" <gernot@tux-web.de>
Subject: Re: Mirroring
Date: Thu, 11 Apr 2002 14:49:14 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204111442160.25430-100000@kopernikus.tux-web.de>
References: <3CB58024.9080008@memscap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3CB58024.9080008@memscap.com>
To: Mohamed Farouk <mohamed.farouk@memscap.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mr Farouk,

> (which contain the boot commands) while the other failed to boot. I
> tried to put a bootable disk but it gives me something related to kernel
> panics.
>

I assume that you wrote the bootdisk when your master disk was running. So
the LILO searches for the root partition on the master disk. When there is
no master disk it fails to read it. I think it should be enough to write a
new MBR with an alternate lilo.conf, which tells the kernel to boot not
the master disks root partition but the slave root partition. In other
words search for the entry root=. It might say something like
root=/dev/hda1. Change it to the slave disk, eg root=/dev/hdb1 (This
example assumes master / in hda1 and slave / on hdb1). Probably lilo won't
write to MBR and complains about hdb being not first disk. But you can
fake this entry. I can't remember the rigth syntax. But I think a quick
google search should solve this problem.

Best wishes,

   Gernot Weber


-- 
Gernot A. Weber
http://www.tux-web.de

Only wimps use tape backup: _real_ men just upload their important stuff
on ftp, and let the rest of the world mirror it.

                              Linus Torvalds, after a hard drive crash

