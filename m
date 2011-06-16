From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Wed, 15 Jun 2011 19:39:23 -0700
Message-ID: <1308191963.29354.1463681709@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com><20110616101812.761f7397@notabene.brown><1308184754.28723.1463652469@webmail.messagingengine.com><20110616112243.22a20610@notabene.brown><1308188856.14820.1463669409@webmail.messagingengine.com>
 <20110616120049.2f01ce88@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616120049.2f01ce88@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 16 Jun 2011 12:00 +1000, "NeilBrown" <neilb@suse.de> wrote:
> On Wed, 15 Jun 2011 18:47:36 -0700 jeffs_linux@123mail.org wrote:
> 
> >> > > cat /dev/.mdadm/map
> > > > ---------------------------------------------------------------
> > > > md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
> > > > md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
> > > > ---------------------------------------------------------------
> > > > 
> > > > mdadm --detail --scan
> > > >         ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
> > > >         UUID=d84afb64:e6fa2b64:ff21c975:f9765431
> > > >         ARRAY /dev/md/0_0 metadata=0.90
> > > >         UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e
> > > 
> > > Yes, that it weird.  I don't know how they came to be out of sync.
> > >   mdadm --incremental --rebuild-map
> > > will fix it..

cat /dev/.mdadm/map
	md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
	md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
mdadm --incremental --rebuild-map
cat /dev/.mdadm/map
	md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2
	/dev/md/jeffadm:jeffadm1
	md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0

Notice that the UUIDs did NOT change, and are thus still out of sync.

BUT, the names did ...

Jeff
