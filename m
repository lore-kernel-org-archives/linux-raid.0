From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] imsm: show Subarray and Volume ID in --examine output
Date: Tue, 17 Mar 2020 17:12:49 -0400
Message-ID: <6bf91263-04a7-b517-92df-640f94518ad2@trained-monkey.org>
References: <20200317092103.7200-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200317092103.7200-1-artur.paszkiewicz@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/17/20 5:21 AM, Artur Paszkiewicz wrote:
> Show the index of the subarray as 'Subarray' and the value of the
> my_vol_raid_dev_num field as 'Volume ID'.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 3 +++
>  1 file changed, 3 insertions(+)

Applied!

Thanks,
Jes
