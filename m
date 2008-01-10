From: dean gaudet <dean@arctic.org>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Wed, 9 Jan 2008 22:25:47 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0801092223510.27277@twinlark.arctic.org>
References: <477FAAAC.2090107@fayettedigital.com> <18305.22361.482483.331552@notabene.brown> <47823B46.6010105@fayettedigital.com> <18306.44011.512618.609434@notabene.brown> <4783E4D7.50602@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4783E4D7.50602@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, jim@fayettedigital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 Jan 2008, Bill Davidsen wrote:

> Neil Brown wrote:
> > On Monday January 7, jim@fayettedigital.com wrote:
> >   
> > > Problem is not raid, or at least not obviously raid related.  The problem
> > > is that the whole disk, /dev/hdb is unavailable.     
> > 
> > Maybe check /sys/block/hdb/holders ?  lsof /dev/hdb ?
> > 
> > good luck :-)
> > 
> >   
> losetup -a may help, lsof doesn't seem to show files used in loop mounts. Yes,
> long shot...

and don't forget "dmsetup ls"... (followed immediately by "apt-get remove 
evms" if you're on an unfortunate version of ubuntu which helpfully 
installed that partition-stealing service for you.)

-dean
