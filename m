From: Maarten <maarten@ultratux.net>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Tue, 16 Sep 2008 19:50:33 +0200
Message-ID: <48CFF1E9.30006@ultratux.net>
References: <48CE250C.8000603@ultratux.net> <20080915125951.GA17966@skl-net.de> <48CE9811.60307@ultratux.net> <20080916082509.GA17300@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080916082509.GA17300@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On 19:14, Maarten wrote:

>> Linux apoc 2.6.23-gentoo-r3 #2 Fri Apr 25 11:09:37 CEST 2008 i686 AMD 
>> Sempron(tm) 2200+ AuthenticAMD GNU/Linux
> 
> My machine is running vanilla 2.6.25.4, i.e. we're using different
> SATA drivers and different kernels.
> 
> While looking at the logs I found a plenty of those:
> 
> 	set_rtc_mmss: can't update from 150 to 43
> 
> And indeed this machine started to have serious problems with its
> clock since last weekend. I found it off by 12 hours yesterday and it
> is still runing much too fast so that ntp is not working any more. I'm
> currently setting the time with a script in 10min intervals...
> 
> Were you also seeing such messages during/after the hard disk failures?

Nope, nothing there.
Strange your clock is so erratic. Maybe the BIOS battery is dead, then 
again I would not be surprised it runs off mains when powered up.


>> I'm considering a 8/12/16 port Areca controller but a few practicalities 
>> hold me back: the price, and the fact I would need a PCI-X slot unless I 
>> want to kill performance by a factor of 10. Also, the fact that I then 
>> cannot use software raid anymore tends to scare me a little: You never 
>> know how firmware reacts in the more 'interesting' circumstances, and 
>> you lose control over it...
> 
> You could use jbod mode (or create single-disk "raid arrays") with
> Areca or 3ware controllers and use software raid on top of that.

True, but then that would kind of defeat the whole purpose of the fairly 
expensive card. In that case a better investment might be a sort of 
servergrade motherboard which has 6 good onboard controllers and at 
least two separate PCI buses for the add-on cards. (For the price of one 
12 port Areca you can already buy a bare bones low-range server...).

The main selling point of most hardware raid cards is that they seem to 
be doing a much better job predicting failure of a drive than software 
raid can. I don't know how they do that, but a fact is I've never even 
heard of a two-disk failure with hardware raid. Which of course doesn't 
say it cannot happen, but it does seem to be a lot less likely somehow.

> Andre

I'm saving the 15 GB data I did not have any backup of elsewhere now and 
will sunsequently start a forced resync and then hot-add the 7th drive.

Maarten
