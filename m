From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] 2.4.18-26.7.x /proc/mdstat seq_file
Date: Thu, 13 Mar 2003 12:03:07 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15983.55499.207149.314602@notabene.cse.unsw.edu.au>
References: <8075D5C3061B9441944E1373776451180F0770@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Tuesday March 11
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 11, ARechenberg@shermanfinancialgroup.com wrote:
> 
> With Kevin's patch from last week and some help from Randy, I patched
> the md code in Red Hat 2.4.18-26.7.x to use the seq_file interface for
> mdstat.  I've attached the patch.  As with Kevin's patch, it touches
> almost everything in drivers/md, as well as adding the necessary methods
> to fs/seq_file.c and include/linux/seq_file.h.

While this patch quite possibly works, I think it misses the point of
seq_file.

seq_file allows you to return the content of a possibly-large file in
lots of little bits, so multiple 'read' calls on the file don't
iterrate over the whole file every time.

I recently sent a patch to Linus for 2.5 that converts /proc/mdstat to
use seq_file using what I understand to be the intended approach, and
I have just posted as similar patch for 2.4 to Marcelo.  I expect it
appeared on linux-raid before you saw this...

NeilBrown
