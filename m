From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: RFC - new raid superblock layout for md driver
Date: 21 Nov 2002 23:11:28 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1037949088.29451.20.camel@ixodes.goop.org>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2002-11-19 at 20:09, Neil Brown wrote:
> My current design looks like:
> 	/* constant array information - 128 bytes */
>     u32  md_magic
>     u32  major_version == 1
>     u32  feature_map     /* bit map of extra features in superblock */
>     u32  set_uuid[4]
>     u32  ctime
>     u32  level
>     u32  layout
>     u64  size		/* size of component devices, if they are all
> 			 * required to be the same (Raid 1/5 */
Can you make 64 bit fields 64 bit aligned?  I think PPC will lay this
structure out with padding before size, which may well cause confusion. 
If your routines to load and save the header don't depend on structure
layout, then it doesn't matter.
        J

