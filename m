From: jlewis@lewis.org
Subject: Re: Array Size
Date: Mon, 12 Jan 2004 00:17:33 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401120011560.1212-100000@redhat1.mmaero.com>
References: <Pine.GSO.4.31.0401112145170.19340-100000@staff1.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.31.0401112145170.19340-100000@staff1.cso.uiuc.edu>
To: Sharif Islam <mislam@ux1.cso.uiuc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Jan 2004, Sharif Islam wrote:

> I have 6 IDE hard drives, each 120 GB.
> I am bit confused by the reported array size.
> 
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Fri Jan  9 13:52:20 2004
>      Raid Level : linear
>      Array Size : 703324416 (670.74 GiB 720.25 GB)

> /dev/md0              661G   33M  627G   1% /ppa
> 
> 
> Shouldn't the above be ~720GB?

It is.  That 720GB is in units of 1000's, while the 670 GiB is in units of 
1024's.  As drives get bigger, the difference in manufacturer advertised 
sizes (measured in 1000s) is getting more noticable when compared to GB 
measured in 1024s.  So, the above is telling you your 720GB is really 
670GiB, and I'm guessing you formatted it ext3 and the journal is taking 
~32mb.  That 627+33 = 660G...and you probably have 10G in reserved blocks.
 
----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

