From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: md/bitmap: move some fields of 'struct bitmap' into a 'storage'
 substruct.
Date: Mon, 23 Apr 2012 13:17:04 +0300
Message-ID: <20120423101704.GA20058@mwanda>
References: <20120420131336.GA26339@elgon.mountain>
 <20120423101049.633d9be7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120423101049.633d9be7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 23, 2012 at 10:10:49AM +1000, NeilBrown wrote:
> On Fri, 20 Apr 2012 16:13:36 +0300 Dan Carpenter <dan.carpenter@ORACLE.COM>
> >   1210			if (test_and_clear_page_attr(bitmap, j,
> >   1211						     BITMAP_PAGE_NEEDWRITE)) {
> >   1212				write_page(bitmap, bitmap->storage.filemap[j], 0);
> >                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Renamed dereference.
> 
> There is a relationship between storage.filemap and storage.file_pages.
> If the later is 0, the former must be non-NULL.
> 
> This dereference only happens if file_pages > 0...  Maybe I should check
> file_pages up above so as not to confuse smatch??
> 

False positives are not really a problem.  I only look at new
warnings.  My dream is that someday Smatch will be able to figure
out the code flow as it is.

regards,
dan carpenter


