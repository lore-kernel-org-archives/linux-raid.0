From: Neil Brown <neilb@suse.de>
Subject: Re: Raid-10 mount at startup always has problem
Date: Fri, 26 Oct 2007 15:59:01 +1000
Message-ID: <18209.33317.886561.478372@notabene.brown>
References: <46D3147D.2040201@amfes.com>
	<46D49F1A.7030409@tmr.com>
	<46E4A39C.8040509@amfes.com>
	<46E4A5F0.9090407@sauce.co.nz>
	<46E4A7C3.1040902@amfes.com>
	<471F5542.3020504@amfes.com>
	<18208.13247.106651.142652@notabene.brown>
	<4720AC60.2040506@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday October 25
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Daniel L. Miller" <dmiller@amfes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 25, davidsen@tmr.com wrote:
> Neil Brown wrote:
> >
> > BTW, I don't think your problem has anything to do with the fact that
> > you are using whole partitions.
> >   
> 
> You don't think the "unknown partition table" on sdd is related? Because 
> I read that as a sure indication that the system isn't considering the 
> drive as one without a partition table, and therefore isn't looking for 
> the superblock on the whole device. And as Doug pointed out, once you 
> decide that there is a partition table lots of things might try to use it.

"unknown partition table" is what I would expect when using whole
drive.
It just mean "the first block doesn't look like a partition table",
and if you have some early block of an ext3 (or other) filesystem in
the first block (as you would in this case), you wouldn't expect it to
look like a partition table.

I don't understand what you are trying to say with your second
sentence.

NeilBrown
