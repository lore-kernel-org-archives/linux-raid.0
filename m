From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.0 and 2.1 compile error
Date: Tue, 27 Sep 2005 09:51:11 +0200
Message-ID: <17208.63983.493938.764444@cse.unsw.edu.au>
References: <Pine.LNX.4.63.0509262217180.24352@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Monday September 26
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 26, raid@a2000.nu wrote:
> I am trying to compile mdadm 2.x (currently running version 1.12)
> 
> On "make" I get the following fatal error for both 2.0 and 2.1:
> 
> In file included from super0.c:31:
> /usr/include/asm/byteorder.h:6:2: #warning using private kernel header; 
> include <endian.h> instead!
> make: *** [super0.o] Error 1
> 
> any idea ?

This means your distro is crazy.  endian.h does not contain the
defines that I need from byteorder.h.
Just remove the '-Werror' from the Makefile and try again.

NeilBrown

> 
> system is tao 1.0 (based on rhel3) with 2.6.13.2 kernel source (also tried 
> 2.6.11.7 source)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
