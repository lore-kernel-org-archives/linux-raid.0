From: Istvan Pusztai <istvanp@gmail.com>
Subject: Resizing/merging partitions on soft RAID
Date: Fri, 13 Jul 2012 22:24:55 -0400
Message-ID: <CAHhFfPZze2BFznqYeMH3Fy4BwcnGzvvmrQgo8hq18Ny5ydYWuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid,

Reddit brought me here but I am not sure this is the right place to
ask for help, but here goes...

I'm new to working with RAID from the command line and I'm having
difficulty trying to resize my RAID 1 array. There is no data at all
on it; it's a fresh CentOS 6.3 minimal install (hence no GUI). Also
note I only have SSH access since this is a dedicated server. I am
booting into Debian 6 for repartitioning if that's pertinent.

I am resizing it because I only have 10GB for the root partition and
990GB for /home which I seldom use (usage is quite mixed on the other
root directories). I essentially want to get rid of sda2 and sdb2 and
have one large root partition of 1TB  (sda1/sdb1) + swap (sda2/sdb2).

Here is the layout of the RAID using output from several commands:
http://pastie.org/4253318 (I can add more information if requested.)
How do I approach this problem? (As much step by step as possible please ^^;)

Istvan
