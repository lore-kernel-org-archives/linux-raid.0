From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Docs and operation of RAID10, size limitations on 0.90
Date: Wed, 30 Jul 2008 12:53:29 -0400
Message-ID: <20080730165329.GB11712@nexus.edgeofthenet.org>
References: <20080728143553.GE30681@nexus.edgeofthenet.org> <4890943E.5060608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4890943E.5060608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Richard Michael <rmichael-raid@edgeofthenet.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 10,f2 read performance is very good, write performance is okay. AFAIK you 
> can't do a split, the object is to spread head motion and improve 
> performance.

Thanks Bill.  "Split-a-bility" is a requirement unfortunately, so maybe
RAID10 is not viable.  

> I usually create a 100MB or so partition, raid1, on my drives and boot off 
> that using 0.90 superblock. The rest of the storage can be anything you 
> want.

Ok; as do I.  I guess I'll do so again to make sure everything works.

Regards,
Richard
