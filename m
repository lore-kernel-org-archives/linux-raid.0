From: Lyle Schlueter <lyle@xkubed.com>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 22:27:19 +0300
Message-ID: <1194377239.17361.53.camel@localhost.localdomain>
References: <1194315635.17361.20.camel@localhost.localdomain>
	 <1194331297.31760.15.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194331297.31760.15.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, I must have missed that. I've only been on the mailing list for a
week or so. I did go through some of the archives though. I keep my
kernel up to date, usually within a few days of a release. 

The 3ware and Areca cards sound nice, but I could buy quite a few drives
for the price of those cards (for a 12 port card). Which is what made me
start seriously considering software raid. Plus, from what I understand,
with software raid it is easier to change out server parts than it is
with hardware raid, i.e. swapping controllers or motherboard, etc.

After reading a few responses that I have gotten, it sounds like a
budget based *raid* card from a good vender with good linux support
might be the best option to get a good number of ports on a PCIe
interface, and have it work well with linux, all well being cheaper than
a full blown hardware raid solution.

Thanks for the info and I will have a look at the cards you mentioned.

Lyle


On Tue, 2007-11-06 at 00:41 -0600, Alberto Alonso wrote:
> You've probably missed a discussion on issues I've been having with
> SATA, software RAID and bad drivers. A clear thing from the responses 
> I got is that you really need to use a recent kernel, as they may have
> fixed those problems.
> 
> I didn't get clear responses indicating specific cards that are 
> known to work well when hardrives fail. But if you can deal with
> a server crashing and then rebooting manually then software RAID
> is the way to go. I've always been able to get the servers back
> online even with the problematic drivers.
> 
> I am happy with the 3ware cards and do use their hardware RAID to
> avoid the problems that I've had. With those I've fully tested
> 16 drive systems with 2 arrays using 2 8-port cards. Others have
> recommended the Areca line.
> 
> As for cheap "dumb" interfaces I am now using the RocketRAID 2220,
> which gives you 8 ports on a PCI-X. I believe the "built" in RAID
> on those is just firmware based so you may as well use them to
> show the drives in normal/legacy mode and use software RAID on
> top. Keep in mind I haven't fully tested this solution nor have
> tested for proper functioning when a drive fails.
> 
> Another inexpensive card I've used with good results is the Q-stor
> PCI-X card, but I think this is now obsolete.
> 
> Hope this helps,
> 
> Alberto
> 
> 
> On Tue, 2007-11-06 at 05:20 +0300, Lyle Schlueter wrote:
> > Hello,
> > 
> > I just started looking into software raid with linux a few weeks ago. I
> > am outgrowing the commercial NAS product that I bought a while back.
> > I've been learning as much as I can, suscribing to this mailing list,
> > reading man pages, experimenting with loopback devices setting up and
> > expanding test arrays. 
> > 
> > I have a few questions now that I'm sure someone here will be able to
> > enlighten me about.
> > First, I want to run a 12 drive raid 6, honestly, would I be better of
> > going with true hardware raid like the areca ARC-1231ML vs software
> > raid? I would prefer software raid just for the sheer cost savings. But
> > what kind of processing power would it take to match or exceed a mid to
> > high-level hardware controller?
> > 
> > I haven't seen much, if any, discussion of this, but how many drives are
> > people putting into software arrays? And how are you going about it?
> > Motherboards seem to max out around 6-8 SATA ports. Do you just add SATA
> > controllers? Looking around on newegg (and some googling) 2-port SATA
> > controllers are pretty easy to find, but once you get to 4 ports the
> > cards all seem to include some sort of built in *raid* functionality.
> > Are there any 4+ port PCI-e SATA controllers cards? 
> > 
> > Are there any specific chipsets/brands of motherboards or controller
> > cards that you software raid veterans prefer?
> > 
> > Thank you for your time and any info you are able to give me!
> > 
> > Lyle
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

