From: Bob Hillegas <bobhillegas@houston.rr.com>
Subject: RE: raidtools vs mdadm
Date: Wed, 08 Sep 2004 21:56:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1094698560.2325.63.camel@south.rosestar.lan>
References: <8075D5C3061B9441944E1373776451186488CB@cinshrexc03.shermfin.com>
	 <1093989799.3399.27.camel@rich> <16693.7624.576505.965545@cse.unsw.edu.au>
	 <1094688667.3533.5.camel@rich>  <16703.42724.466092.958285@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16703.42724.466092.958285@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-09-08 at 19:42, Neil Brown wrote:
> On Wednesday September 8, rich@storix.com wrote:
> > On Tue, 2004-08-31 at 17:54, Neil Brown wrote:
> > > On Tuesday August 31, rich@storix.com wrote:
> > >  
> > > > i realize that raid devices created with raidtools and raid devices
> > > > created with mdadm can co-exist. is there an easy way to know which
> > > > method was used to create them?
> > > 
> > > It is impossible to know.  There is no difference.
> > if i were to read the superblock myself, would it look different for
> > devices created with mdadm than with devices created with raidtools?
> 
> No.  There is no different.  Zero.  They are the same thing.
> 
> >  i
> > am trying to figure out a way of knowing which tool was used to create
> > them in the event that we need to rebuild them. any difference i can
> > count on consistently is what i am looking for. the problem is that if
> > we recreate raid devices using mdadm and their init scripts dont start
> > the raid devices then the devices will not be assembled, and could
> > possibly cause the system to not boot.
> 
> How you create the array and how you start the array are two different
> things.  They don't need to be done with the same tool.
> 
> If the init scripts don't start an array created with mdadm, then they
> won't start an array created with raidtools either.

Actually, some initscripts (I'm familiar with FC2) do a sanity check for
the existence of configuration files. I created my array with mdadm but
didn't bother to set up /etc/raidtab. the absence of /etc/raidtab as a
file caused the initscripts (rc.sysinit) to skip trying to start the
raid.

Once I modified rc.sysint to test for /etc/mdadm.conf and use mdadm
--assemble --scan, everything worked fine. 

Mileage varies depending on how the initscript was written. and how you
have provided configuration details.

> 
> NeilBrown
> -
-- 
------------------------------
Bob Hillegas
bobhillegas@houston.rr.com

