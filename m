From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace monitoring of events.
Date: Mon, 6 Sep 2004 16:02:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040906140233.GB20941@lst.de>
References: <20040903122034.15346.patches@notabene> <E1C33nX-00040i-9v@notabene.cse.unsw.edu.au> <20040903031920.11e31d3f.akpm@osdl.org> <16699.47090.307180.958993@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16699.47090.307180.958993@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On Mon, Sep 06, 2004 at 11:05:54AM +1000, Neil Brown wrote:
> > Christoph points out that this is fairly wild procfs abuse.  We want to be
> > moving away from that sort of thing, not adding to it.
> 
> I guess it depends on what you mean by "wild procfs abuse"...
> Given that /proc/mdstat already exists it doesn't seem too
> unreasonable to add a little functionality to it.  How much does it hurt?

poll on procfs is defintily abuse, even in categories of the use procfs
every times.

> > Is it possible to use rml's new event stuff from rc1-mm3's
> > kernel-sysfs-events-layer.patch?  Or a bare netlink interface?  Or
> > raidfs?
> 
> sysfs:  
>   Probably.  I would like to improve sysfs support for md but I
>   haven't taken the plunge yet to figure out how it all works.
>   kevents may well be ok, but as you may need to handle
>   multipath-failed events in times if high memory pressure, and need
>   to handle it before pressure can be relieved, I prefer to minimise
>   the number of kmallocs needed to get the event to userspace.
> 
> bare netlink:
>   Probably perter sysfs... Funny, but I remember reading a comment in
>   the code (2.4 I think, ages ago) about netlink being deprecated or
>   something like that, so I never bothered looking at it.  I wonder
>   what it meant.

netlink isn't deprecated, netlink_dev (aka netlink as chardevice nodes)
is.

