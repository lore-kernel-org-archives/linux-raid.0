From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Mon, 30 Jun 2008 11:23:48 +0200
Message-ID: <20080630092348.GJ17557@boogie.lpds.sztaki.hu>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18533.20961.694041.556763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike McCarthy <mike@w1nr.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 28, 2008 at 06:47:29AM +1000, Neil Brown wrote:

> >    System locks up after running a short time.  Had it hang once during 
> > installation.  Tried both Reiserfs and EXT3.
> 
> We need more details about the lockup.  Does the whole system lock up,
> or just the array.
> Can  you get
>    alt-sysrq-T
> output?  That might be useful.

Also, try to set up netconsole and boot with nmi_watchdog=2. I've now 3
completely different HW setups where 2.6.25 hangs due to HPET issues.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
