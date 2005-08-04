From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 question.
Date: Fri, 5 Aug 2005 06:53:23 +1000
Message-ID: <17138.32835.190046.8088@cse.unsw.edu.au>
References: <17137.43778.476908.961140@cse.unsw.edu.au>
	<01f001c598fd$c59a51a0$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Thursday August 4
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 4, djani22@dynamicweb.hu wrote:
> Hi list, Neil!
> 
> I have a little question because I'v got some performance problem...

What performance problem?

> Is the RAID5 do any type of headahead with the default config?

Technically: no.
raid5 itself doesn't do readahead.
The filesystem or VM layer does read-ahead.
The block device can suggest the sort of read-ahead size which might
be appropriate.

> It is possible to disable the readahead? (if it is.)

This has been answered - man blockdev
But you almost certainly don't want to. 

> Or just the io_sched do that on the disks?
> 
> How can I disable the whole headahead on top of the RAID5 array?
> 
> The RAID5 can do multiple small (<4kb) reads of disks for the multithreaded
> read requests?
> (chunk size is 32k)

Multiple small random read requests should evenly distribute over all
drives and give reasonable performance.

But again, you haven't said what your problem is....

NeilBrown

> 
> Thanks for helping!
> 
> Janos
