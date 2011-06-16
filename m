From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Wed, 15 Jun 2011 18:47:36 -0700
Message-ID: <1308188856.14820.1463669409@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com><20110616101812.761f7397@notabene.brown><1308184754.28723.1463652469@webmail.messagingengine.com>
 <20110616112243.22a20610@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616112243.22a20610@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 16 Jun 2011 11:22 +1000, "NeilBrown" <neilb@suse.de> wrote:
> > Ok.  I got beaten up for top posting once, and was told to 'keep things
> > in order'.  Next time, though -- question first, in BOTH the title and
> > the body.
> 
> :-)  You can't win, can you...

Not even checkers with my son ;-)

> When you use --examine, it tries to use the name that people might like.
> When you use --detail --scan it primarily has access to the names the
> kernel
> likes, so it used those.

Thanks for that.  Into my notes ...

> > cat /dev/.mdadm/map
> > ---------------------------------------------------------------
> > md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
> > md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
> > ---------------------------------------------------------------
> > 
> > mdadm --detail --scan
> >         ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
> >         UUID=d84afb64:e6fa2b64:ff21c975:f9765431
> >         ARRAY /dev/md/0_0 metadata=0.90
> >         UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e
> 
> Yes, that it weird.  I don't know how they came to be out of sync.
> 
>   mdadm --incremental --rebuild-map
> 
> will fix it..

Ok.  This is officially the first time that I'll actually try to fix
anything on my 'production' array.

I'm reading the manpage -- again! -- and see both the "--incremental"
and "--rebuild-map" sections.  So I get what they do.

WHEN can/should I do it?  On my live running array while at runlevel 5? 
A lower runlevel?  From a separate boot disk?

jeff
