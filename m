From: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Subject: Re: Moving RAID 1 array to new server
Date: 12 Nov 2003 20:08:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1068682124.5087.8.camel@localhost.localdomain>
References: <news2mail-bordad$avv$1@cartman.spoiled.org>
	 <1068509010.907.4.camel@forbidden.jrc.net>
	 <news2mail-bordad$avv$1@cartman.spoiled.org>
	 <1068603164.908.6.camel@forbidden.jrc.net> <3015.3fb20027.f253c@altium.nl>
	 <news2mail-bou3ck$q2i$1@cartman.spoiled.org>
	 <1068667243.1477.35.camel@forbidden.cipanb.ca>
	 <news2mail-bou3rq$q2i$2@cartman.spoiled.org>
	 <1068680238.5087.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1068680238.5087.4.camel@localhost.localdomain>
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-11-12 at 19:37, Jean-Rene Cormier wrote:
> On Wed, 2003-11-12 at 16:06, Juri Haberland wrote:
> > Jean-Rene Cormier <jean-rene.cormier@cipanb.ca> wrote:
> > > On Wed, 2003-11-12 at 15:58, Juri Haberland wrote:
> > 
> > > I use 2.4.22 so I guess this patch is not for me. When I get home
> > > tonight I'll try to re-add the disk to the array and see what it does.
> > 
> > If it doesn't work please also post the relevant part of /proc/mdstat.
> 
> 
> Well I re-added the drive and it marked it as a spare.

> It seems to be rebuilding but will it stay marked as a spare drive or
> will it take over the main faulty drive after it's done rebuilding?
> 

Well the array just finished syncing and both drive are marked as active
sync without any spare drive so I guess it answered my question.

Thanks

Jean-Rene Cormier

