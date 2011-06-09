From: Nagilum <nagilum@nagilum.org>
Subject: Re: Possible to use multiple disk to bypass I/O wait?
Date: Thu, 09 Jun 2011 14:06:16 +0200
Message-ID: <20110609140616.20962w476u7juc00@cakebox.homeunix.net>
References: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: CentOS mailing list <centos@centos.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- Message from centos.admin@gmail.com ---------
     Date: Thu, 9 Jun 2011 17:24:23 +0800
     From: Emmanuel Noobadmin <centos.admin@gmail.com>
  Subject: Possible to use multiple disk to bypass I/O wait?
       To: CentOS mailing list <centos@centos.org>, linux-raid  
<linux-raid@vger.kernel.org>


> I'm trying to resolve an I/O problem on a CentOS 5.6 server. The
> process basically scans through Maildirs, checking for space usage and
> quota. Because there are hundred odd user folders and several 10s of
> thousands of small files, this sends the I/O wait % way high. The
> server hits a very high load level and stops responding to other
> requests until the crawl is done.
>
> I am wondering if I add another disk and symlink the sub-directories
> to that, would that free up the server to respond to other requests
> despite the wait on that disk?

Have you tried using ionice -c 3  on the process?


----- End message from centos.admin@gmail.com -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
