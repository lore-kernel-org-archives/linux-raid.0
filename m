From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: /proc/partitions
Date: Tue, 21 Dec 2004 09:26:00 +1100
Message-ID: <16839.20856.770312.358967@cse.unsw.edu.au>
References: <200411210433.iAL4XIN19967@www.watkins-home.com>
	<Pine.LNX.4.61.0411220909180.5652@treant.hhmi.umbc.edu>
	<41A281AD.8050404@verizon.net>
	<41A301DA.4010303@robinbowes.com>
	<1101213077.2244.6.camel@south.rosestar.lan>
	<Pine.LNX.4.56.0412201046050.4389@lion.drogon.net>
	<20041220114939.GA20243@inara.maison.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from KELEMEN Peter on Monday December 20
Sender: linux-raid-owner@vger.kernel.org
To: KELEMEN Peter <Peter.Kelemen@cern.ch>, Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 20, Peter.Kelemen@cern.ch wrote:
> * Gordon Henderson (gordon@drogon.net) [20041220 10:50]:
> 
> > Is there any plans to make the entries in /proc/partitions
> > return anything sensible for the md devices?
...
> 
> PS: 2.6.x same thing

No, easy in 2.6

See /proc/diskstats

NeilBrown
