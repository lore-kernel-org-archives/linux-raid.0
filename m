From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] mdraid: fix read/write bytes accounting
Date: Mon, 8 Jun 2020 09:13:02 +0200
Message-ID: <ed552b4b-b19a-cc85-05f4-0a0dc0d6fac2@intel.com>
References: <20200605201953.11098-1-jeffm@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200605201953.11098-1-jeffm@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: jeffm@suse.com, linux-raid@vger.kernel.org, song@kernel.org
Cc: nfbrown@suse.com, colyli@suse.com
List-Id: linux-raid.ids

On 6/5/20 10:19 PM, jeffm@suse.com wrote:
> The i/o accounting published in /proc/diskstats for mdraid is currently
> broken.  md_make_request does the accounting for every bio passed but
> when a bio needs to be split, all the split bios are also submitted
> through md_make_request, resulting in multiple accounting.

Hi Jeff,

I sent a patch a few days ago which should fix this issue. Can you check
it out?

https://marc.info/?l=linux-raid&m=159102814820539

Thanks,
Artur
