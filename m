From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
Date: Tue, 18 Nov 2003 15:48:55 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311182348.hAINmo204434@bzs.org>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi folks..
> 
> hopefully everything will be working soon and i can get on with
> trying to get some backup scripts working :)
> 
> I am going to stick with this software RAID for the near future if
> it carries on working correctly.. I was just wondering what peoples
> views were of software vs hardware raid... anything and everything
> really.. I'm not that up on all the technology... I know that 3ware
> have a good rep in hardware... I also imagine that for more exotic
> RAID configurations its obviously a help to not stress the CPU with
> the RAID tasks.. for me tho with simple mirroring the CPU costs are
> minimal.. the linux core is a sturdy base to build upon so is
> software raid in this way a perfectly acceptible reliable RAID
> solution..
> 

Your choice is to use "hardware" raid which is really just software 
raid implemented with a little bitty processor and some firmware, or 
"software" raid which is open source and runs on your honken' 
big-fast (relatively speaking) main processor. For i86 this means 
that the raid parity calculations are carried out by the mmi unit 
which sits idle most of the time anyway. It would be tough to 
actually find the missing cpu cycles. I've not done the benchmarks, 
but others on the list claim that software raid is faster than any of 
the hardware implimentations. My experience with several raid cards 
leads me to believe that software raid is far more robust.

Michael
running linux software raid since 1996
