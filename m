From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid on extended partitions
Date: Wed, 2 Jun 2004 09:16:59 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16573.3691.298127.116803@cse.unsw.edu.au>
References: <16571.56114.265798.791241@cse.unsw.edu.au>
	<20040601151312.72047.qmail@web61003.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from M K on Tuesday June 1
To: M K <maheshext3@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 1, maheshext3@yahoo.com wrote:
> 
> --- Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > 
> > What does
> >    ls -l /dev/hd[eg]5
> > show? How about
> >    cat /proc/partitions
> >    dd if=/dev/hde5 of=/dev/null bs=1024k
> 
> Thanks a lot, Neil, turns out those nodes were not
> present. After I mknod'd them, all's fine in
> RAIDland... 
>   Quick question: does using extended partitions for
> RAID affect performance?

The fact that the partitions are "extended" is invisible to most of
the kernel, and it could not have any affect of performance.

NeilBrown
