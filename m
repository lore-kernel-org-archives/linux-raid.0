From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 09:52:03 -0700
Message-ID: <428A2133.4080202@h3c.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Jay Strauss <me@heyjay.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Gordon Henderson wrote:

> However, I notice that Sarge isn't using multicount. You can turn that on
> with hdparm -m 16 /dev/hda /dev/hdc
> 
> To work out your IDE controller, try: lspci and have a look at the output
> of /var/log/dmesg (or just type dmesg | less - knoppix might not create a
> /var/log/dmesg) The output of lspci will tell you what hardware you have
> then you'll need to examinf the dmesg output to see if you have support
> for it, or need to compile it in.
> 
> Gordon

I was sure it would be DMA too :-). Wonder if multicount makes that much
of a difference?

Either way, one of the first things I typically do on a server is add an
hdparm line with whatever the disks need for that particular machine.
Usually it goes in rc.sysinit or rc.local or similar.

In particular, drives like to enable write-caching out of the box now,
which opens a window for data corruption that has bitten more than a few
high-profile sites as it causes the disk to break the fsync contract
which in turn bubbles up and breaks the 'D' part of the ACID contract
for databases (or journalling filesystems).

So, even if you can't get your distribution to tune your IDE chipset and
IDE hard drives perfectly, with something like multicount or write
caching, its effective (IMHO) to just force your settings on boot.

-Mike
