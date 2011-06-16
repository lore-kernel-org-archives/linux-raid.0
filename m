From: NeilBrown <neilb@suse.de>
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Thu, 16 Jun 2011 11:22:43 +1000
Message-ID: <20110616112243.22a20610@notabene.brown>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
	<20110616101812.761f7397@notabene.brown>
	<1308184754.28723.1463652469@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308184754.28723.1463652469@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeffs_linux@123mail.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 17:39:14 -0700 jeffs_linux@123mail.org wrote:

> 
> 
> On Thu, 16 Jun 2011 10:18 +1000, "NeilBrown" <neilb@suse.de> wrote:
> > ---- cut lots of detail-----
> > It is very good to include lots of detail, but more effective you include
> > it
> > after you have asked the question, otherwise one gets bored long before
> > one
> > reaches the actual question....
> 
> Ok.  I got beaten up for top posting once, and was told to 'keep things
> in order'.  Next time, though -- question first, in BOTH the title and
> the body.

:-)  You can't win, can you...

> 
> > > I get different results for each one.
> > 
> > It is just the different names that has you bothered - correct?
> 
> No, not just the names. I guess I don't know the PURPOSE of the names,
> if the names we give things aren't necessarily the ones that get used.

Well there is the names that people like to use (/dev/md/jeffadm) and names
that the kernel likes to use (md1, md2, md127).

When you use --examine, it tries to use the name that people might like.
When you use --detail --scan it primarily has access to the names the kernel
likes, so it used those.

> 
> But more a problem are the different UUID's:.
> 
> cat /dev/.mdadm/map
> ---------------------------------------------------------------
> md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
> md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
> ---------------------------------------------------------------
> 
> mdadm --detail --scan
>         ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
>         UUID=d84afb64:e6fa2b64:ff21c975:f9765431
>         ARRAY /dev/md/0_0 metadata=0.90
>         UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e

Yes, that it weird.  I don't know how they came to be out of sync.

  mdadm --incremental --rebuild-map

will fix it..

NeilBrown


> 
> 
> Notice that the UUIDs for /dev/md/0_0 match, but for /dev/md127 the
> don't.
> 
> 
> jeff

