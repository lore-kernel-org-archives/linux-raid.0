From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] md: override md superblock recovery_offset for cache
 device
Date: Tue, 4 Aug 2015 07:30:07 -0700
Message-ID: <20150804143007.GB8204@infradead.org>
References: <cover.1438215986.git.shli@fb.com>
 <42ac39ae4466dda63b1dee827c2bd3741d669860.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42ac39ae4466dda63b1dee827c2bd3741d669860.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Jul 29, 2015 at 05:38:42PM -0700, Shaohua Li wrote:
> Cache device stores data in a log structure. We need record the log
> start. Here we override md superblock recovery_offset for this purpose.
> This field of a cache device is meaningless otherwise.

Just reusing the field for a different purpose without a different
name or comment is highly confusing.

I'd suggest to create unions in both the on-disk and in-memory
structures and properly document that new usage for cache devices.
