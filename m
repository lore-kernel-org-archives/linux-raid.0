From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Tue, 27 Jun 2006 19:55:46 +1000
Message-ID: <17569.162.835803.817439@cse.unsw.edu.au>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
	<17567.25412.387397.430549@cse.unsw.edu.au>
	<8764ingcmb.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nix on Tuesday June 27
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 27, nix@esperi.org.uk wrote:
> > And the code in load_partitions() handles a NULL return.
> 
> Er, what?
> 
> The code in load_partitions() in mdadm 2.5.1 and below says
> 
> ,----[ config.c:load_partitions() ]
> | name = map_dev(major, minor, 1);
> | 
> | d = malloc(sizeof(*d));
> | d->devname = strdup(name);
> `----
> 

Ahh.. uhmmm... Oh yes.  I've fixed that since, but completely forgot
about it and the change log didn't make it obvious.
 From
    http://neil.brown.name/git/?p=mdadm

           28 hours ago 	Neil Brown 	More consistent honoring of --configfile
           28 hours ago 	Neil Brown 	Fix user-after-free bug in error path in --monitor ...
           28 hours ago 	Neil Brown 	Improve ftw handling.
           31 hours ago 	Neil Brown 	Fix a recently introduced bug, and make --assemble ...
           31 hours ago 	Neil Brown 	Work around bug in --add handling for version-1 superb ...
           31 hours ago 	Neil Brown 	Add 'Array Slot' line to --examine for version-1 superb ...
           31 hours ago 	martin f krafft 	Fix manpage typo 
           31 hours ago 	Neil Brown 	Get the changelog uptodate for recent changes.
           7 days ago 	Paul Clements 	Move a variable declaration to the declaration area.
this one-> 7 days ago 	Neil Brown 	Stop map_dev from returning [0:0] 
           7 days ago 	Paul Clements 	Fix problem with post-increment usage in macro 
           11 days ago 	Neil Brown 	Release 2.5.1 

So: that's fixed for 2.5.2.  Thanks for following it up.

NeilBrown
