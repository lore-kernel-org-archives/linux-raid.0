From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Stress testing system?
Date: Mon, 11 Oct 2004 09:38:31 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0410110919530.9395@lion.drogon.net>
References: <4167078A.3030609@robinbowes.com> <Pine.LNX.4.56.0410082257450.26162@lion.drogon.net>
 <4167264B.8070507@robinbowes.com> <Pine.LNX.4.56.0410102122140.9395@lion.drogon.net>
 <4169AB0B.1040709@robinbowes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4169AB0B.1040709@robinbowes.com>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 10 Oct 2004, Robin Bowes wrote:

> This gave the following results:
>
> Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>                      -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> dude.robinbow 3096M 13081  95 34159  75 12617  21 15311  92 40429  30 436.1   3
> dude.robinbowes.com,3096M,13081,95,34159,75,12617,21,15311,92,40429,30,436.1,3,,,,,,,,,,,,,
>
> I don't actually know what the figures mean - is this fast??

It's not brilliant, but reasonable for a RAID5 on IDE drives. Disk head
bandwidth for comodity 7200 RPM drives is about 55MB/sec peak - although I
haven't been able to get that with the SATA controllers I've used so-far,
but I suspect thats because they are running in PATA mode.

This is a Dell with 4 SCSI drivers split over 2 controllers:

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
pixel         2000M 20492  72 54865  12 28260   6 25413  86 108190  13 332.9   0


This is a dual-Athlon with 5 IDE drives (4+hot spare)

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
red           1023M 14216  99 26663  25 17697  13 13767  95 72211  34 239.5   2

This is anothe dual athlon with just 4 IDE drives:

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
blue          1023M 12003  99 40147  44 24048  19 12078  98 87887  46 232.6   2

Your block input seems a shade low, but this is what I experienced on a
server with SATA drives which look like /dev/hdX drives. I suspect the
drivers have a bit more development to go through though.

And in any-case, depending on what you are using it for, it's probably
fast enough anyway... 100Mb Ethernet can only chuck files out at 10MB/sec
anyway, but it's always nice to have bandwidth in-hand!

Gordon
