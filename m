From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
Date: Tue, 23 Jan 2007 22:57:47 -0800
Message-ID: <20070123225747.caa15292.akpm@osdl.org>
References: <20070123112437.29357.patches@notabene>
	<1070123002652.29462@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1070123002652.29462@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Jan 2007 11:26:52 +1100
NeilBrown <neilb@suse.de> wrote:

> +					for (j = 0; j < vcnt ; j++)
> +						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
> +						       page_address(pbio->bi_io_vec[j].bv_page),
> +						       PAGE_SIZE);

I trust these BIOs are known to only contain suitably-allocated, MD-private
pages?  Because if these pages can be user pages then this change is
spectacularly buggy ;)

