From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
Date: Fri, 21 Nov 2008 12:55:26 -0500
Message-ID: <4926F60E.6040104@tmr.com>
References: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan> <49269BCF.8060300@rabbit.us> <20081121115415.6c872f11@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0811210657110.5577@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811210657110.5577@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, martmontools-support@lists.sourceforge.net, Bruce Allen <ballen@gravity.phys.uwm.edu>, westerndigital@custhelp.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Fri, 21 Nov 2008, Alan Cox wrote:
>
>>> Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
>>
>> Different error. IDNF -> ID not found
>>
>
> So the only thing in common is WD disks.  I don't know at this point.. 
> NCQ with
> WD disks (at least raptor150s/300s) is completely broken and I have to 
> disable
> it to use the disks without NCQ errors and dropping out of arrays (on 
> 3 diff)
> systems with different chipsets, p35, 965.
>
> This guy has the same errors I do when I enable NCQ.  It seems like WD 
> raptors
> should be blacklisted from using NCQ in the kernel.
>
> NCQ: http://lkml.org/lkml/2007/10/17/380
>
> Concerning my error specifically:
>
> How much time have you spent replacing and RMA'ing disks?  Personally 
> for me
> I spent $3600 on new velociraptors but after having spend hours, days 
> with
> doing testing, replacing, I have spent much more in time than the 
> drives are
> worth.  I am really getting sick and tired of it, every few days or 
> every week
> its another drive failure (or more). What are you plans, just keep 
> RMA'ing and hopefully they'll find the bug and fix it or just give up 
> and build a new system for production and the RMA'ing can be a hobby 
> in another system?
>
> What I meant when I asked did you buy them new, was, did you buy them 
> recently,
> because with the raptor150s I have in another system, all 1+ year old, 
> bought
> new but I wonder if they changed something in their firmware to cause 
> this
> problem, when I opened a case with WD about the issue and spoke with 
> someone
> in India they are only setup to answer basic questions and anything 
> complicated
> you will get canned answer: "RMA."
>
> Time to dump WD raptor drives?
>
> I will note I am using several 750GiB drives without any issue whether
> NCQ is enabled or disabled in various raid and non-raid configurations.
>
> Comments--buggy raptors?

Well I guess I will have some data points after the weekend... I just 
got a new WD 1TB on sale from Newegg, and I'm going to be using it 
raid10 with a raid0 of a pair of Seagate 500GB, and expect to beat it 
somewhat severely moving data from place to place.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


