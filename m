From: Troels Bang Jensen <troels@x.dtu.dk>
Subject: RAID6 reassembly oddities
Date: Tue, 16 Jan 2007 18:44:15 +0100
Message-ID: <45AD0EEF.8060102@x.dtu.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've had a RAID6, which has been running with a failed drive for a while.
Last week I finally got around to ordering a handful of drives, which is
just as well, since another drive failed this sunday.

Now, as some of us know hard drives have an uncanny tendency to fail all
at the same time, so after I had installed two new drives and hot-added
one of them, another drive failed. This brought the RAID down to four
drives out of seven, which of course isn't enough to run the array.

However, the reason I'm not panicking yet is that the most recently thrown
drives seems to be sorta-kinda working; when I reboot from the four-drive
state, I can add the drive and the RAID then begins rebuilding with it

(btw, what exactly goes on during that rebuild? It's just the minimal
number of drives for the RAID to be functional)

-after the rebuild I can mount the RAID, apparently without any file
system corruption (I haven't tried a full scan, though - I've been more
concerned with adding redundancy).

Because of the way the system maps the drives, I've had to reboot for
everything to work properly - which it does. I get no weird log messages
anywhere.

I then hot-add one of the fresh drives, the system rebuilds...and when
it's done, it drops the fresh drive *and* the one that was the last to be
kicked from the array, leaving the array in a four-drive non-functional
state <insert profanity here>.

So, that puts me where I was, and I can start over again. I've done this
procedure twice because I got the impression that the drive which gets
kicked did this because it has intermittent errors, but I've become
convinced that the problem is in software rather than hardware.

I'm using a 2.6.18 kernel in Debian Sarge with mdadm 2.5.6 - 9.nov 2006

Any suggestions on what I can do about it will be greatly appreciated.

Regards, Troels
