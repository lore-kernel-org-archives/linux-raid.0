From: NeilBrown <neilb@suse.de>
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Thu, 16 Jun 2011 12:00:49 +1000
Message-ID: <20110616120049.2f01ce88@notabene.brown>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
	<20110616101812.761f7397@notabene.brown>
	<1308184754.28723.1463652469@webmail.messagingengine.com>
	<20110616112243.22a20610@notabene.brown>
	<1308188856.14820.1463669409@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308188856.14820.1463669409@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeffs_linux@123mail.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 18:47:36 -0700 jeffs_linux@123mail.org wrote:

>> > > cat /dev/.mdadm/map
> > > ---------------------------------------------------------------
> > > md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
> > > md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
> > > ---------------------------------------------------------------
> > > 
> > > mdadm --detail --scan
> > >         ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
> > >         UUID=d84afb64:e6fa2b64:ff21c975:f9765431
> > >         ARRAY /dev/md/0_0 metadata=0.90
> > >         UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e
> > 
> > Yes, that it weird.  I don't know how they came to be out of sync.
> > 
> >   mdadm --incremental --rebuild-map
> > 
> > will fix it..
> 
> Ok.  This is officially the first time that I'll actually try to fix
> anything on my 'production' array.
> 
> I'm reading the manpage -- again! -- and see both the "--incremental"
> and "--rebuild-map" sections.  So I get what they do.
> 
> WHEN can/should I do it?  On my live running array while at runlevel 5? 
> A lower runlevel?  From a separate boot disk?
> 

Any time at all is fine.  The 'map' file is used to help with incremental
assembly of arrays.  When "mdadm -I" is given a device that looks like part of
an array it looks in the map file to find out if any of that array has already
been assembled.
So one everything is assembled it is not interesting any longer.

I think you can even just remove it.  If mdadm needs it and finds it doesn't
exist, it perform the equivalent of "mdadm --incremental --rebuild", then
tries again.

So it really is safe to run it at any time that you aren't actively rebooting
or plugging in new devices.

NeilBrown
