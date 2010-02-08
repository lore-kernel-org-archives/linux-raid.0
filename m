From: Neil Brown <neilb@suse.de>
Subject: Re: problem changing raid level with Ubuntu 10.04 / 2.6.32 / mdadm
 3.1.1
Date: Mon, 8 Feb 2010 16:42:53 +1100
Message-ID: <20100208164253.4e6277fb@notabene.brown>
References: <alpine.DEB.1.10.1002031944020.31777@uplift.swm.pp.se>
	<alpine.DEB.1.10.1002032009410.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002032009410.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Feb 2010 20:12:32 +0100 (CET)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:


> Any reason this doesn't work with a bitmap, and if it doesn't, then 
> perhaps this should be documented somewhere or at least mdadm should throw 
> an error message?
> 

It doesn't work with a bitmap because md is not able to resize the bitmap
which might be needed when resizing an array.
The next release of mdadm should provide a more helpful message.
I'll look in to ways of getting md to resize the bitmap.

NeilBrown
