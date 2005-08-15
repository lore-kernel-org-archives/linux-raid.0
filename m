From: Jon Lewis <jlewis@lewis.org>
Subject: Re: confused raid1
Date: Mon, 15 Aug 2005 13:29:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0508151326210.10349@soloth.lewis.org>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org>
 <4300BC7E.6030009@dtbb.net> <Pine.LNX.4.61.0508151202160.10349@soloth.lewis.org>
 <4300C5D6.3090706@dtbb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4300C5D6.3090706@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Aug 2005, Tyler wrote:

> Try this suggestion (regarding modules.conf).
>
> https://www.redhat.com/archives/fedora-list/2003-December/msg05205.html

I don't see why that modules.conf addition would be necessary / make a 
difference.  I have other servers with root-raid1 that haven't needed 
that, and mkinitrd is smart enough (reads /etc/raidtab) to know that raid1 
is needed and loads the raid1 module in the initrd linuxrc script.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                | 
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
