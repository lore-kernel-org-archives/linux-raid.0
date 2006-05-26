From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 08:11:26 -0600
Message-ID: <1148652686.3100.4.camel@hendrix.hollabaugh.com>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
	 <17526.7947.129968.287311@cse.unsw.edu.au>
	 <1148596237.4957.4.camel@hendrix.hollabaugh.com>
	 <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had no idea about this particular configuration requirement. None of
my reading mentioned setting the partition type. I originally created
the array 1/2003 and don't remember having to set it. So, yes, more
debugging info in dmesg would have saved me days of
resyncing/tweak/reboot/resync cycles. (I'm not complaining, just very
relieved to up and running again).
 



On Fri, 2006-05-26 at 09:57 +0200, Mikael Abrahamsson wrote:
> On Thu, 25 May 2006, Craig Hollabaugh wrote:
> 
> > That did it! I set the partition FS Types from 'Linux' to 'Linux raid 
> > autodetect' after my last re-sync completed. Manually stopped and 
> > started the array. Things looked good, so I crossed my fingers and 
> > rebooted. The kernel found all the drives and all is happy here in 
> > Colorado.
> 
> Would it make sense for the raid code to somehow warn in the log when a 
> device in a raid set doesn't have "Linux raid autodetect" partition type? 
> If this was in "dmesg", would you have spotted the problem before?
> 
-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com

