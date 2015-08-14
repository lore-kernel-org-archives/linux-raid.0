From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH stable] md/bitmap: return an error when bitmap superblock
 is corrupt.
Date: Fri, 14 Aug 2015 10:23:51 -0700
Message-ID: <20150814172351.GB17745@kroah.com>
References: <20150814170421.60d40eb0@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150814170421.60d40eb0@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: stable@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, GuoQing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 14, 2015 at 05:04:21PM +1000, NeilBrown wrote:
> 
> commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49 upstream
>     Use separate bitmaps for each nodes in the cluster
> 
> bitmap_read_sb() validates the bitmap superblock that it reads in.
> If it finds an inconsistency like a bad magic number or out-of-range
> version number, it prints an error and returns, but it incorrectly
> returns zero, so the array is still assembled with the (invalid) bitmap.
> 
> This means it could try to use a bitmap with a new version number which
> it therefore does not understand.
> 
> This bug was introduced in 3.5 and fix as part of a larger patch in 4.1.
> So the patch is suitable for any -stable kernel in that range.
> 
> Fixes: 27581e5ae01f ("md/bitmap: centralise allocation of bitmap file pages.")
> Cc: stable@vger.kernel.org (v3.5..v4.1)

b97e92574c0 is in 4.1, so do you mean (v3.5..v4.0) here?

thanks,

greg k-h
