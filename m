From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Wed, 2 Jul 2008 12:50:34 +0200
Message-ID: <20080702105034.GC29303@boogie.lpds.sztaki.hu>
References: <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de> <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net> <486A4E7B.50604@tmr.com> <486A6291.20207@w1nr.net> <20080701194508.GB6177@astaroth.intranet.mb-net.net> <20080702103754.GB29303@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080702103754.GB29303@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Bussmann <bus@mb-net.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 12:37:54PM +0200, Gabor Gombas wrote:
> On Tue, Jul 01, 2008 at 09:45:08PM +0200, Michael Bussmann wrote:
> 
> > So far I tried
> > 	- Replaced IDE cables
> > 	- kernel upgrades up to 2.6.25.9
> > 	- removed one drive from the RAID, thus running in degraded mode
> > 	- disabled CPU frequency scaling
> > 	- put one drive on the PDC20276, the other on the ICH4 (82801DB)
> 
> Set up netconsole or serial console, boot with nmi_watchdog=2, and wait
> for a lockup.

Some motivation: I have a feeling that the HPET problem in 2.6.25 is
actually biting people other than me. But if you do not enable the NMI
watchdog and do not have a way to save the resulting Oops, then you
will never know what hit you. SysRq+W will show tasks blocked in places
related to disk I/O, but that's not the real reason, so messing with
the disks will not help you in this case.

And this also explains why machines w/o HPET (or HPET being disabled by
the BIOS or otherwise unaffected for yet unknown reasons) can run
2.6.25.x just fine.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
