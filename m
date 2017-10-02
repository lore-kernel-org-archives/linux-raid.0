From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: New disk controller domains
Date: Mon, 2 Oct 2017 15:43:11 -0400
Message-ID: <f9cce2f5-dba1-4d50-34a3-f4660ae90be1@gmail.com>
References: <1504793109-16291-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504793109-16291-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/07/2017 10:05 AM, Mariusz Tkaczyk wrote:
> Add disk controller domain for nvme and vmd devices to prevent moving
> spares between different domains.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   super-intel.c | 4 ++++
>   1 file changed, 4 insertions(+)

Applied!

Thanks,
Jes

