From: Wolfram Schlich <lists@schlich.org>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 08:10:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320071023.ALLYOURBASEAREBELONGTOUS.B6336@bla.fasel.org>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org> <15993.2378.97234.342504@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15993.2378.97234.342504@notabene.cse.unsw.edu.au>
To: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

* Neil Brown <neilb@cse.unsw.edu.au> [2003-03-20 01:26]:
> On Thursday March 20, lists@schlich.org wrote:
> > Hi,
> > 
> > I just trashed my RAID5 array. The Promise IDE driver messed up
> > sharing IRQs with a network interface card while writing a file to
> > the array via the mentioned NIC card.
> > Is any recovery possible? I wouldn't care about some lost
> > megabytes... really. Thanks in advance!
> 
> I recommend:
> 	mdadm -A /dev/md1 --force /dev/sd[egik]1

Thanks for the hint! (small typo - it's hdX, not sdX)
How are the chances of success/failure/losing all data completely?
Well, I guess I just don't have any choice, do I? :-)
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
