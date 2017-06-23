From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH] fs: buffer: Modify alloc_page_buffers.
Date: Fri, 23 Jun 2017 16:26:25 +0800
Message-ID: <20170623082622.GA31615@linux-zmni.apac.novell.com>
References: <1497877296-22441-1-git-send-email-fxinrong@gmail.com>
 <20170619160315.GD10672@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170619160315.GD10672@ZenIV.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: shli@kernel.org, anton@tuxera.com, jack@suse.cz, axboe@fb.com, ebiggers@google.com, rpeterso@redhat.com, bmarzins@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
List-Id: linux-raid.ids

On Mon, Jun 19, 2017 at 05:03:16PM +0100, Al Viro wrote:
> On Mon, Jun 19, 2017 at 09:01:36PM +0800, Sean Fu wrote:
> > Make alloc_page_buffers support circular buffer list and initialise
> > b_state field.
> > Optimize the performance by removing the buffer list traversal to create
> > circular buffer list.
> 
> > -		bh = head = alloc_page_buffers(page, blocksize, 1);
> > +		bh = head = alloc_page_buffers(page, blocksize, 1, 0, 0);
> 
> Frankly, I don't like that change of calling conventions; it's very easy to
> mess the order of arguments when using interfaces like that and it's hell
> to find when trying to debug the resulting mess.
> 
> Do you really get an observable change in performance?  What loads are
> triggering it?
Sorry for my mistake.
Infact, The time of writting a large file depends on saveral other
factors, eg system workload.
Yesterday, I tried to test the time of single calling create_empty_buffers by kretprobe
and found that the performance difference is too small to measure it.

before:
[  944.632027] create_empty_buffers returned 878736736 and took 2160 ns
to execute
[  944.632286] create_empty_buffers returned 878962832 and took 451 ns
to execute
[  944.632302] create_empty_buffers returned 878962016 and took 226 ns
to execute
[  944.632728] create_empty_buffers returned 878962832 and took 235 ns
to execute
[  944.633105] create_empty_buffers returned 878962832 and took 167 ns
to execute
[  944.633421] create_empty_buffers returned 878962832 and took 160 ns
to execute

after:
[39209.076519] create_empty_buffers returned 383804768 and took 1666 ns
to execute
[39209.077032] create_empty_buffers returned 383804768 and took 366 ns
to execute
[39209.077120] create_empty_buffers returned 558412336 and took 179 ns
to execute
[39209.077127] create_empty_buffers returned 558413152 and took 148 ns
to execute
[39209.077525] create_empty_buffers returned 558412336 and took 201 ns
to execute
[39209.078255] create_empty_buffers returned 814328768 and took 880 ns
to execute
[39209.078498] create_empty_buffers returned 558412336 and took 564 ns
to execute
[39209.078737] create_empty_buffers returned 558413152 and took 196 ns
to execute

This patch also complicates code.
Please ignore it.
Thanks all of you.
