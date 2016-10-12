From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 0/8] raid5-cache: enabling cache features
Date: Wed, 12 Oct 2016 10:52:02 -0700
Message-ID: <20161012175202.GA58645@kernel.org>
References: <20161011002446.2002428-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161011002446.2002428-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Oct 10, 2016 at 05:24:38PM -0700, Song Liu wrote:
> These are the 4th version of patches to enable write cache part of
> raid5-cache. The journal part was released with kernel 4.4.
> 
> The caching part uses same disk format of raid456 journal, and provides
> acceleration to writes. Write operations are committed (bio_endio) once
> the data is secured in journal. Reconstruct and RMW are postponed to
> reclaim path, which is (hopefully) not on the critical path.
> 
> The changes are organized in 8 patches (details below).
> 
> Patch for chunk_aligned_read in earlier RFC is not included yet
> (http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
> some optimizations later, especially for SSD raid devices.
> 
> Changes from PATCH v3 (http://marc.info/?l=linux-raid&m=147573807306070):
>   1. Make reclaim robust
>   2. Fix a bug in recovery
> 
> Changes between v3 and v2 (http://marc.info/?l=linux-raid&m=147493266208102):
>   1. Incorporate feedback from Shaohua
>   2. Reorganize the patches, for hopefully easier review
>   3. Make sure no change to write through mode (journal only)
>   4. Change reclaim design to avoid deadlock due to log space

Could you please add a test case for this in mdadm test suites?

Thanks,
Shaohua
