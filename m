From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Wed, 24 Mar 2004 21:21:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40624235.30108@pobox.com>
References: <760890000.1079727553@aslan.btc.adaptec.com>	<16479.50592.944904.708098@notabene.cse.unsw.edu.au>	<2128160000.1080023015@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16480.61927.863086.637055@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Choice is good.  Competition is good.  I would not try to interfere
> with you creating a new "emd" driver that didn't interfere with "md". 
> What Linus would think of it I really don't know.  It is certainly not
> impossible that he would accept it.

Agreed.

Independent DM efforts have already started supporting MD raid0/1 
metadata from what I understand, though these efforts don't seem to post 
to linux-kernel or linux-raid much at all.  :/


> However I'm not sure that having three separate device-array systems
> (dm, md, emd) is actually a good idea.  It would probably be really
> good to unite md and dm somehow, but no-one seems really keen on
> actually doing the work.

I would be disappointed if all the work that has gone into the MD driver 
is simply obsoleted by new DM targets.  Particularly RAID 1/5/6.

You pretty much echoed my sentiments exactly...  ideally md and dm can 
be bound much more tightly to each other.  For example, convert md's 
raid[0156].c into device mapper targets...  but indeed, nobody has 
stepped up to do that so far.

	Jeff



