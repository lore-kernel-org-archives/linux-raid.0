From: Bob Hillegas <bobhillegas@houston.rr.com>
Subject: Re: Raid1 auto-detection...
Date: Wed, 25 Aug 2004 23:17:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093493854.2398.22.camel@south.rosestar.lan>
References: <1093473322.2398.12.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093473322.2398.12.camel@south.rosestar.lan>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know it's bad form to reply to your own message, but I just resolved
my problem.

The Fedora Core 2 kernel isn't the source of the problem. It's the
rc.sysinit script. It expects to use raidstart and so checks for the
presence of the /etc/raidtab file. Since I don't have one, no attempt
was made to start the raid.

I'll hammer together changes to allow mdadm --assemble --scan to start
the raid and then post when it works.

Thanks, BobH


On Wed, 2004-08-25 at 17:35, Bob Hillegas wrote:
> I am currently using Fedora Core 2 kernel 2.6.8-1.521smp. I have set up
> a raid1 on /dev/md0 from /dev/sda1 & /dev/sdb1. Both partitions have
> been set to type 0xfd.
> 
> When I boot the raid is not started. After the boot has completed I can
> manually mdadm --assemble --scan & mdadm --stop --scan, so I know I have
> a workable raid1 setup.
> 
> Q1) How do I check the kernel to see whether auto-detection is included?
> 
> Q2) Can you point me to a good site for compiling in auto-detection?
> 
> Thanks, BobH
-- 
------------------------------
Bob Hillegas
bobhillegas@houston.rr.com

