From: dean gaudet <dean@arctic.org>
Subject: Re: UUID's
Date: Sat, 9 Sep 2006 22:14:04 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609092204430.18380@twinlark.arctic.org>
References: <4501E9C6.10403@sauce.co.nz> <Pine.LNX.4.64.0609082011050.8584@twinlark.arctic.org>
 <45023FDF.3060606@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45023FDF.3060606@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 9 Sep 2006, Richard Scobie wrote:

> To remove all doubt about what is assembled where, I though going to:
> 
> DEVICE partitions
> MAILADDR root
> ARRAY /dev/md3 UUID=xyz etc.
> 
> would be more secure.
> 
> Is this correct thinking on my part?

yup.

mdadm can generate it all for you... there's an example on the man page.  
basically you just want to paste the output of "mdadm --detail --scan 
--config=partitions" into your mdadm.conf.

-dean
