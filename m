From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Moving RAID 1 array to new server
Date: Thu, 13 Nov 2003 13:08:04 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16306.59268.973057.368159@notabene.cse.unsw.edu.au>
References: <news2mail-bordad$avv$1@cartman.spoiled.org>
	<1068509010.907.4.camel@forbidden.jrc.net>
	<1068603164.908.6.camel@forbidden.jrc.net>
	<3015.3fb20027.f253c@altium.nl>
	<news2mail-bou3ck$q2i$1@cartman.spoiled.org>
	<1068667243.1477.35.camel@forbidden.cipanb.ca>
	<news2mail-bou3rq$q2i$2@cartman.spoiled.org>
	<1068680238.5087.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jean-Rene Cormier on  November 12
To: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Cc: Juri Haberland <juri@koschikode.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  November 12, jean-rene.cormier@cipanb.ca wrote:
> And here's my /proc/mdstat:
> 
> Personalities : [raid1] [raid5]
> read_ahead 1024 sectors
> md0 : active raid1 hdg1[2] hde1[0]
>       60051456 blocks [2/1] [U_]
>       [=>...................]  recovery =  6.9% (4162176/60051456)
> finish=30.2min speed=30762K/sec
> unused devices: <none>
> 
> It seems to be rebuilding but will it stay marked as a spare drive or
> will it take over the main faulty drive after it's done rebuilding?
> 

Wait 30.2 minutes and see?
It should mark it as a fully active drive, no longer spare.

NeilBrown
