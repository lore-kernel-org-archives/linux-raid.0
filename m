From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 19:38:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4035571B.505@pobox.com>
References: <Pine.LNX.4.44.0402191118090.10623-100000@praktifix.dwd.de> <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu> <20040219175630.GA20790@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040219175630.GA20790@datavibe.net>
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rev. Jeffrey Paul wrote:
> I have always avoided the promise fasttrak cards for exactly that 
> reason ("hardware" being in quotes).  It's my understanding that 
> they're not much more than their udma cards with drivers that do most 
> of the RAIDing.

Actually, Promise is one of the very few companies that are doing 
something innovative in RAID...  Their hardware is not 100% software 
RAID nor 100% hardware RAID.  They instead follow the model of network 
cards -- perform all key operations on the board, and let the host CPU 
handle the rest.


> It was also my understanding that the 3ware cards are true hardware 
> raid and are up to the task of something like this, which would also 
> explain why they're 4x the cost.

Correct.


> I am looking at a four disk raid5 or raid10, and it seems like 
> the interrupt load from four drives on four channels might be a bit 
> excesive.  I'm going to be running critical services on the machine 
> that the drives are in (namely mysql and nfs) and don't want to worry 
> about performance.

Once your spindles can max out your PCI bus bandwidth, -then- you can 
start worrying about PCI bandwidth and interrupt load ;-)

	Jeff



