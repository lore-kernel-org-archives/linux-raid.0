From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 02 Aug 2004 11:07:21 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091470041.11770.95.camel@tinny.home.foo>
References: <Pine.LNX.4.44.0408021401260.27289-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408021401260.27289-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-08-02 at 11:02, Mark Hahn wrote:
> > According to Adaptec, their 16 port card with 64bit 66MHz PCI will 
> > transfer up to 1.5gigabit/s. That's a tad low I must say, that's only 190 
> 
> I think they're clearly pulling a marketing-weasel on you:
> the 1.5 gbps is from sata's peak/theoretical/never data rate.

I routinely get 1.5 Gbits/sec on my 3ware, 8 port (8506-8) controller. 
8 SATA, 250GB WD disks (JBOD mode).  Like the Adaptec, it is also a
64bit 66MHz PCI.

Of course, reads are 1 megabyte each (but random on disk, not
sequential), but still, it is possible.

	Scott


