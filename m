From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Sun, 18 Jan 2004 17:26:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074464762.2532.95.camel@localhost.localdomain>
References: <1074459283.2532.50.camel@localhost.localdomain>
	 <20040118212933.GB3763@hvs.envisage.co.za>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040118212933.GB3763@hvs.envisage.co.za>
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thx.

I found that in 2.4.x kernel, there are not much sata support. In 2.6
there are some. and basing on that sata linxu status report, i think
promise and serverworks should be good choices i guess. i find a promise
4 port card. but i do not know which card use server works chips.

just feel curious why u use evms not lvm? :)

ming


On Sun, 2004-01-18 at 16:29, Hendrik Visage wrote:
> On Sun, Jan 18, 2004 at 03:54:44PM -0500, Ming Zhang wrote:
> > Hi, I want to setup a software raid and lvm configuration with 2-4TB raw
> > disk space. I wonder if you can give me some suggestions on what kind of
> > sata controllers are friendly to my purpose? :)
> 
> Those supported properly in the kernel :)
> 
> At present I'm using the onboard Via & Promise (20378) for SATA + (evms)
> software RAID, but there are others that have different views on which
> controller(s) to use.
> 
> Hendrik

