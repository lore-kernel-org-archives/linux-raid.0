From: Stephen C Woods <scw@seas.ucla.edu>
Subject: Re: =?iso-8859-1?Q?=BF_the_best_journalist-filesystem_for_a_?=
Date: Thu, 3 Jul 2003 08:51:39 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307031551.IAA10204@washington.seas.ucla.edu>
References: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130> from "system_lists@nullzone.org" at Jul 03, 2003 05:42:51 PM
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

JFS seems to be a bit buggy still, we went with ext3 on LVM.
  The bug we had was that everyonce in a while, under heavy load it
would just lockup waiting on something in the JSF stack.
<scw>

> 
> Hi there,
> 
>     i dont wanna create a discusion between gurus. My question is so simple 
> (well .. its not simple but ...).
> 
> What do u think is the best journalist filesystem for a software raid5 of 
> 4*120 GB IDE UATA ?
> I will use this one for big files (lots of them) and small ones (just a ftp 
> but too for the users space).
> 
> For a non-specific BIG/SMALL files .... JFS? Reiser3? Reiser4? EXT3?
> 
> Thanks!

-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
