From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Unable to read superblock
Date: Tue, 23 Jul 2002 13:57:49 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15676.54333.424977.14113@notabene.cse.unsw.edu.au>
References: <20020718033404.GR17829@riseup.net>
	<20020722234502.GP12736@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Micah Anderson on Monday July 22
To: Micah Anderson <micah@riseup.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 22, micah@riseup.net wrote:
> I never received a reply to my problem, is it because there isn't
> anyone who knows why it is not working? Should I provide some more
> information?
> 

Sometimes you have to ask twice...  

> > 
> > request module [block major 3]: root fs not mounted
> > cannot open root device hda3

Looks to me like you compiled a kernel that doesn't know about you IDE
controller.  Is that possible??

NeilBrown
