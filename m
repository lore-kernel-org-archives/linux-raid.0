From: Nagilum <nagilum@nagilum.org>
Subject: Re: Problem re-shaping RAID6
Date: Fri, 18 Jun 2010 12:53:48 +0200
Message-ID: <20100618125348.50065jeinmy70vsw@cakebox.homeunix.net>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
 <20100614091518.2492a9db@notabene.brown>
 <20100614124723.84152dz5al8096f4@cakebox.homeunix.net>
 <20100617154708.227cd303@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617154708.227cd303@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


----- Message from neilb@suse.de ---------

> A sector will always be 512 bytes to Linux, even when we have drives that can
> only do IO in multiples of 8 sectors.

Oh, I didn't know that.

> Yes,  I could possibly use a define for '512'.  Some times that is
> appropriate, but I thing 512 is so clearly "bytes_per_sector" it would just
> add an unnecessary level of indirection.
> It is a question of taste really - no right answers.

Yep, thanks for the explanation!




========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
