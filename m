From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] imsm: pass subarray id to kill_subarray function
Date: Mon, 24 Feb 2020 16:08:40 -0500
Message-ID: <b3730e05-c8e6-78fc-e852-14042c0008c5@trained-monkey.org>
References: <20200219095449.29443-1-blazej.kucman@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200219095449.29443-1-blazej.kucman@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/19/20 4:54 AM, Blazej Kucman wrote:
> After patch b6180160f ("imsm: save current_vol number")
> current_vol for imsm is not set and kill_subarray()
> cannot determine which volume has to be deleted.
> Volume has to be passed as "subarray_id".
> The parameter affects only IMSM metadata.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  Kill.c        | 2 +-
>  mdadm.h       | 3 ++-
>  super-ddf.c   | 2 +-
>  super-intel.c | 9 ++++-----
>  4 files changed, 8 insertions(+), 8 deletions(-)

Applied!

Thanks,
Jes
