From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Mon, 19 Dec 2005 11:57:29 +1100
Message-ID: <17318.1401.296396.667001@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
	<17300.58327.193597.248431@cse.unsw.edu.au>
	<035b01c5fc4b$416c98f0$0400a8c0@dcccs>
	<17304.50474.390938.734714@cse.unsw.edu.au>
	<001101c5fc75$a28cb230$0400a8c0@dcccs>
	<17305.3277.821697.223406@cse.unsw.edu.au>
	<000001c5eb50$4e6fada0$a700a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Thursday November 17
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 17, djani22@dynamicweb.hu wrote:
> Hello,
> 
> Now i trying the patch....
> 
> [root@st-0001 root]# mdadm -G --bitmap=/raid.bm /dev/md0
> mdadm: Warning - bitmaps created on this kernel are not portable
>   between different architectured.  Consider upgrading the Linux kernel.
> mdadm: Cannot set bitmap file for /dev/md0: Cannot allocate memory

How big is your array?
The default bitmap-chunk-size when the bitmap is in a file is 4K, this
makes a very large bitmap on a large array.
Try a larger bitmap-chunk size e.g.

   mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0

> [root@st-0001 root]# free
>              total       used       free     shared    buffers     cached
> Mem:       2073152      75036    1998116          0          4      29304
> -/+ buffers/cache:      45728    2027424
> Swap:            0          0          0
> [root@st-0001 root]# mdadm -X /dev/md0

This usage is only appropriate for arrays with internal bitmaps (I
should get mdadm to check that..).
> 
> And now what? :-)

Either create an 'internal' bitmap, or choose a --bitmap-chunk size
that is larger.

Thanks for the report.

NeilBrown
