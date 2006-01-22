From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Need to upgrade to latest stable mdadm version?
Date: Sun, 22 Jan 2006 18:20:47 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601221817190.20336@lion.drogon.net>
References: <200601221241.54689.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601221241.54689.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 22 Jan 2006, Mitchell Laks wrote:

> So I have to compile my own 2.6.15 kernel. So what version of mdadm do I use?
> How shall I install it?

I'm using a stock (www.kernel.org) 2.6.15 kernel on several Debian Sarge
servers and just using the debian packaged mdadm. Seems to work OK.

> Does it make sense to simply compile mdadm  2.2 and replace /sbin/mdadm with
> the new version?????? How can I get the best recent mdadm? I am using raid1.

Personally, I'd say don't upgrade unless you actually need the features of
the latest & gratest....

Debian sarge ships with 1.9.0:

  eagle:~# uname -a
  Linux eagle 2.6.15 #1 PREEMPT Sat Jan 21 15:59:40 GMT 2006 i686 GNU/Linux
  eagle:~# mdadm --version
  mdadm - v1.9.0 - 04 February 2005
  eagle:~# dpkg -l | fgrep mdadm
  ii  mdadm          1.9.0-4sarge1  Manage MD devices aka Linux Software Raid

Gordon
