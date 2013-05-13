From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 3/8] mtd: use generic helper to set max_discard_sectors
Date: Mon, 13 May 2013 10:08:02 +0300
Message-ID: <1368428882.5360.3.camel@sauron.fi.intel.com>
References: <1365860324-21295-1-git-send-email-linkinjeon@gmail.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365860324-21295-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org, Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de, cjb@laptop.org, adrian.hunter@intel.com, linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Vivek Trivedi <t.vivek@samsung.com>
List-Id: linux-raid.ids

On Sat, 2013-04-13 at 22:38 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> It is better to use blk_queue_max_discard_sectors helper
> function to set max_discard_sectors as it checks
> max_discard_sectors upper limit UINT_MAX >> 9
> 
> similar issue was reported for mmc in below link
> https://lkml.org/lkml/2013/4/1/292

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy
