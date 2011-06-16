From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Wed, 15 Jun 2011 17:39:14 -0700
Message-ID: <1308184754.28723.1463652469@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
 <20110616101812.761f7397@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616101812.761f7397@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 16 Jun 2011 10:18 +1000, "NeilBrown" <neilb@suse.de> wrote:
> ---- cut lots of detail-----
> It is very good to include lots of detail, but more effective you include
> it
> after you have asked the question, otherwise one gets bored long before
> one
> reaches the actual question....

Ok.  I got beaten up for top posting once, and was told to 'keep things
in order'.  Next time, though -- question first, in BOTH the title and
the body.

> > I get different results for each one.
> 
> It is just the different names that has you bothered - correct?

No, not just the names. I guess I don't know the PURPOSE of the names,
if the names we give things aren't necessarily the ones that get used.

But more a problem are the different UUID's:.

cat /dev/.mdadm/map
---------------------------------------------------------------
md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
---------------------------------------------------------------

mdadm --detail --scan
        ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
        UUID=d84afb64:e6fa2b64:ff21c975:f9765431
        ARRAY /dev/md/0_0 metadata=0.90
        UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e


Notice that the UUIDs for /dev/md/0_0 match, but for /dev/md127 the
don't.


jeff
