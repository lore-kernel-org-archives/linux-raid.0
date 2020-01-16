From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] imsm: Disable --dump/--restore options
Date: Thu, 16 Jan 2020 13:51:04 -0500
Message-ID: <95c22f71-e85b-cdfd-8b07-6bddf135d8cc@trained-monkey.org>
References: <20200110105927.5965-1-blazej.kucman@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200110105927.5965-1-blazej.kucman@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/10/20 5:59 AM, Blazej Kucman wrote:
> Currently --dump/--restore are not working correctly.
> Temporarily disable this functionally for IMSM
> to avoid unexpected behaviors and side effects.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>

I dislike leaving the code in there dead, especially as it's not clear
when this will get fixed.

Should we just remove it, or do you have plans to fix this in the near
future?

Thanks,
Jes
