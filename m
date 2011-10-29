From: CoolCold <coolthecold@gmail.com>
Subject: raid(1) and block caching
Date: Sat, 29 Oct 2011 08:49:09 +0400
Message-ID: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!

There is holywar once again on nginx maillist about standalone drives
vs raid1 arrays for serving static files. By standalone drives it is
assumed that file "Filename1" exist on /mnt/disk1, /mnt/disk2,
/mnt/diskN where /mnt/diskX is mountpoint for drives /dev/sdY.

As there are some pros and cons on both sides (at least theoretically)
 I have dumb question - let's say our array md1 consists on 3 drives -
/dev/sd{a,b,c} - and when data read from md1 occurs, which block is
cached in VFS (or may be other cache in system, it would be nice to
know which part of system is doing caching)  - the block from md1
itself or from certain drive? If it is drive-based block cache, it's
gonna be potentially memory wasting to keep 3 similar data copies, so
I assume md does data reads with something like O_DIRECT flag, but as
I 1) don't know C 2) don't know kernel, I'm asking this on the list to
make this clean for myself.

-- 
Best regards,
[COOLCOLD-RIPN]
