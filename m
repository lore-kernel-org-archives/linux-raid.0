From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Bit-Rot
Date: Mon, 6 Mar 2017 13:56:48 +0200
Message-ID: <20170306115648.GG7497@reaktio.net>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
 <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
 <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 05, 2017 at 09:15:39AM +0100, Mikael Abrahamsson wrote:
> On Fri, 3 Mar 2017, Gandalf Corvotempesta wrote:
> 
> >This is what ZFS does. This is what Gluster does. This is what BRTFS does.
> >Adding this in mdadm could be an interesting feature.
> 
> This has been discussed several times. Yes, it would be interesting.
> It's not easy to do because mdadm maps 4k blocks to 4k blocks. Only
> way to "easily" add this I imagine, would be to have an additional
> "checksum" block, so that raid6 would require 3 extra drives instead
> of 2.
> 
> The answer historically has been "patches welcome".
> 

There was/is an early prototype implementation of checksums for Linux MD RAID:

http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/
http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-presentation.pdf
http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf
http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-code.tar.bz2


Also there's the T10 DIF / DIX (Data Integrity Fields / Data Integrity eXtensions) functionality that could be used, at least if the hardware setup is SAS-based (SAS HBA + enterprise SAS disks and modern enough firmware on both that enable DIF/DIX..).

I guess MD RAID could also 'emulate' T10 DIF/DIX even if the HBA/disks don't support it.. but dunno if that makes any sense.

> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se


-- Pasi

