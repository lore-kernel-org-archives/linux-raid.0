From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 008 of 10] md: Allow raid 'layout' to be read and set via sysfs.
Date: Wed, 31 May 2006 22:34:59 -0700
Message-ID: <20060601053459.GL2697@moss.sous-sol.org>
References: <20060601150955.27444.patches@notabene> <1060601051408.27637@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060601051408.27637@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

* NeilBrown (neilb@suse.de) wrote:
> +static struct md_sysfs_entry md_layout =
> +__ATTR(layout, 0655, layout_show, layout_store);

0644?
