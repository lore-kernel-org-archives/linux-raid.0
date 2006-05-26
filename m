From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 11:49:07 -0600
Message-ID: <1148665748.2836.40.camel@hendrix.hollabaugh.com>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
	 <17526.7947.129968.287311@cse.unsw.edu.au>
	 <1148596237.4957.4.camel@hendrix.hollabaugh.com>
	 <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
	 <44773BAC.9090002@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44773BAC.9090002@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael and others,
I forgot to answer your question from a previous post. Yes, if I had
received a warning in dmesg, I would have spotted this problem. Or at
least been pointed to something to research. When I switched to the
newest kernel, I didn't even get the kicking non-fresh message, just a
list of added drives. The lack of information got me even more
concerned. 

From a user perspective, here's where the disconnect occurred for me.
After the re-sync and my array was stable running with a spare, I could
start it and stop it, mount it and unmount it without any issues. Whew,
things are looking good, my data is safe. I thought everything was good
to go. I reboot the machine and my array comes up degraded. mdadm -D
reports something completely different than what it reported before the
reboot. dmesg gives little clues about kernel raid build process. 

The disconnect for me occurs between mdadm assembling the array from
userspace and the kernel auto-detecting, binding and running. I was
under the impression that mdadm and the kernel assemble arrays in the
same fashion. In my situation where my new drive's partition types were
different, that's not quite true. 

Thanks for the help.
Craig
ps. I'm old-school here, none of my 10+ Linux hosts run logwatch, dmesg
is fine for me.



On Fri, 2006-05-26 at 13:32 -0400, Bill Davidsen wrote:
> Mikael Abrahamsson wrote:
> 
> > On Thu, 25 May 2006, Craig Hollabaugh wrote:
> >
> >> That did it! I set the partition FS Types from 'Linux' to 'Linux raid 
> >> autodetect' after my last re-sync completed. Manually stopped and 
> >> started the array. Things looked good, so I crossed my fingers and 
> >> rebooted. The kernel found all the drives and all is happy here in 
> >> Colorado.
> >
> >
> > Would it make sense for the raid code to somehow warn in the log when 
> > a device in a raid set doesn't have "Linux raid autodetect" partition 
> > type? If this was in "dmesg", would you have spotted the problem before?
> >
> As long as it is written where logwatch will see it, not recognize it, 
> and report it... People who don't read their logwatch reports get no 
> sympathy from me.
> 
-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com

