From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] policy.c: Avoid to take spare without defined domain by
 imsm
Date: Sun, 21 Jan 2018 16:19:39 -0500
Message-ID: <7ce74f86-3346-0d72-bbb5-15c544fe7b27@gmail.com>
References: <1515670789-30835-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1515670789-30835-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2018 06:39 AM, Mariusz Tkaczyk wrote:
> Only Imsm get_disk_controller_domain returns disk controller domain for
> each disk. It causes that mdadm automatically creates disk controller
> domain policy for imsm metadata, and imsm containers in the same disk
> controller domain can take spare for recovery.
> 
> Ignore spares if only one imsm domain is matched.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  policy.c | 4 ++++
>  1 file changed, 4 insertions(+)

Applied!

Thanks,
Jes


