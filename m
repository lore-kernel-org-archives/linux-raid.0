From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mdadm 2.0 and 2.1 compile error
Date: Mon, 24 Oct 2005 11:48:51 -0700 (PDT)
Message-ID: <djjaaj$j0h$1@terminus.zytor.com>
References: <Pine.LNX.4.63.0509262217180.24352@adsl.a2000.nu> <17208.63983.493938.764444@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <17208.63983.493938.764444@cse.unsw.edu.au>
By author:    Neil Brown <neilb@suse.de>
In newsgroup: linux.dev.raid
> 
> This means your distro is crazy.  endian.h does not contain the
> defines that I need from byteorder.h.
> Just remove the '-Werror' from the Makefile and try again.
> 
> NeilBrown
> 

-Werror is (arguably) great for local debugging, but it's a bad idea
to use for distributed software.

	-hpa
