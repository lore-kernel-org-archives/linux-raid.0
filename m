From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] Show device as journal in --detail --examine
Date: Tue, 1 Sep 2015 23:53:03 -0700
Message-ID: <20150902065303.GA20708@infradead.org>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
 <1440804426-1461372-3-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440804426-1461372-3-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org
List-Id: linux-raid.ids

>  #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
> +#define	MD_FEATURE_JOURNAL		512 /* support write journal */

The kernel patches are using 256 here, so your userspace won't work
with them but rather generate very unhelpful warnings:

[   16.177710] md: sdc does not have a valid v1.2 superblock, not importing!
[   16.178634] md: md_import_device returned -22
mdadm: ADD_NEW_DISK for /dev/sdc failed: Invalid argument
