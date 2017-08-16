From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Detail: correct output for active arrays
Date: Wed, 16 Aug 2017 04:20:00 -0400
Message-ID: <2e245bec-4d58-cabb-3372-001600cf6b59@gmail.com>
References: <1502358228-26458-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502358228-26458-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2017 05:43 AM, Mariusz Tkaczyk wrote:
> The check for inactive array is incorrect as it compares it against
> active array. Introduce a new function md_is_array_active so the check
> is consistent across the code.
> 
> As the output contains list of disks in the array include this
> information in sysfs read.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   Detail.c | 15 +++++++--------
>   mdadm.h  |  1 +
>   util.c   | 15 +++++++++------
>   3 files changed, 17 insertions(+), 14 deletions(-)

Applied!

Thanks,
Jes

