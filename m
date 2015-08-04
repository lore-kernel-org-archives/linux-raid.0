From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] MD: add a new disk role to present cache device
Date: Tue, 4 Aug 2015 07:28:24 -0700
Message-ID: <20150804142824.GA8204@infradead.org>
References: <cover.1438215986.git.shli@fb.com>
 <e871cc4fc266c76f1d4b55225f2c0a6aacb18680.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e871cc4fc266c76f1d4b55225f2c0a6aacb18680.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

>  		case 0xfffe: /* faulty */
>  			set_bit(Faulty, &rdev->flags);
>  			break;
> +		case 0xfffd: /* cache device */

Any chance to get constants for these magic numbers as an additional
prep patch?

Also I don't really think that adding the role without the actual
implementation is that useful.

