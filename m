From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: raidtools vs mdadm
Date: Thu, 9 Sep 2004 10:42:12 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16703.42724.466092.958285@cse.unsw.edu.au>
References: <8075D5C3061B9441944E1373776451186488CB@cinshrexc03.shermfin.com>
	<1093989799.3399.27.camel@rich>
	<16693.7624.576505.965545@cse.unsw.edu.au>
	<1094688667.3533.5.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rich turner on Wednesday September 8
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 8, rich@storix.com wrote:
> On Tue, 2004-08-31 at 17:54, Neil Brown wrote:
> > On Tuesday August 31, rich@storix.com wrote:
> >  
> > > i realize that raid devices created with raidtools and raid devices
> > > created with mdadm can co-exist. is there an easy way to know which
> > > method was used to create them?
> > 
> > It is impossible to know.  There is no difference.
> if i were to read the superblock myself, would it look different for
> devices created with mdadm than with devices created with raidtools?

No.  There is no different.  Zero.  They are the same thing.

>  i
> am trying to figure out a way of knowing which tool was used to create
> them in the event that we need to rebuild them. any difference i can
> count on consistently is what i am looking for. the problem is that if
> we recreate raid devices using mdadm and their init scripts dont start
> the raid devices then the devices will not be assembled, and could
> possibly cause the system to not boot.

How you create the array and how you start the array are two different
things.  They don't need to be done with the same tool.

If the init scripts don't start an array created with mdadm, then they
won't start an array created with raidtools either.

NeilBrown
