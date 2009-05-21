From: Neil Brown <neilb@suse.de>
Subject: Re: Subject [ md PATCH 4/6] : md to support page size chunks in
	the case of raid 0
Date: Thu, 21 May 2009 13:13:57 +1000
Message-ID: <18964.50933.544742.732019@notabene.brown>
References: <1242687989.21201.16.camel@raz>
	<18962.444.630305.895248@notabene.brown>
	<20090520075117.GQ6403@skl-net.de>
	<18963.55483.993420.606497@notabene.brown>
	<1242826211.3322.60.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Wednesday May 20
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 20, raziebe@gmail.com wrote:
> > 
> > In general, we just want to delay the test until we are in personality
> > code and do it there.
> why not add a new method ? pers->validate_parms ?  

because a new method should not be necessary.  We should be able to
manage with what we have - or even fewer...

NeilBrown
