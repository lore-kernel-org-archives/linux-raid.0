From: Nagilum <nagilum@nagilum.org>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Thu, 07 Apr 2011 22:13:34 +0200
Message-ID: <20110407221334.16604ufejmh3q9s0@cakebox.homeunix.net>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: rob pfile <rpfile@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm, I think you could:
  - add a disk,
  - reshape your raid5 to raid6 while using the layout where the raid5  
disks aren't really changed
  - let it finish syncing
  - reshape the raid6 to raid5 taking one of the bad disks out

I'm sure Neil will let us know if this is nonsense. ;)
Alex.

----- Message from rpfile@gmail.com ---------
     Date: Wed, 6 Apr 2011 18:45:15 -0700
     From: rob pfile <rpfile@gmail.com>
  Subject: 4-disk raid5 with 2 disks going bad: best way to proceed?
       To: linux-raid@vger.kernel.org

> is there a way to construct a clean copy of one of the disks even if  
> there are raid-correctable read errors?

----- End message from rpfile@gmail.com -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
