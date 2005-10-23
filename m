From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Mon, 24 Oct 2005 08:52:13 +1000
Message-ID: <17244.5149.366493.721487@cse.unsw.edu.au>
References: <20050916125754.11044.patches@notabene>
	<1050916030157.11071@suse.de>
	<62b0912f050920171550edcab1@mail.gmail.com>
	<17201.9323.915024.189868@cse.unsw.edu.au>
	<435B0A3B.9000801@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Patrik Jonsson on Saturday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 22, patrik@ucolick.org wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> After having the "dreaded double disk failure", I've decided to upgrade
> my kernel and include this patch. I also want to include the "parity
> check" option. However, I'm having a hard time figuring out which
> patches need to be applied. Is there a collection of all the md patches
> somewhere? It's also hard to know which patches have already been
> included in the kernel when you upgrade to a newer version.
> 
> Any tips for handling this would be much appreciated!

The easiest thing to do would be to grab the latest -mm kernel.  All
the patches are in there.

NeilBrown
