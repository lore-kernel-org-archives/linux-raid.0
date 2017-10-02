From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Monitor: Check redundancy for arrays
Date: Mon, 2 Oct 2017 15:44:26 -0400
Message-ID: <f4e15ee5-8bbd-1c00-9e8d-1e88159aa85e@gmail.com>
References: <1504522366-21913-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504522366-21913-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/2017 06:52 AM, Mariusz Tkaczyk wrote:
> GET_MISMATCH option doesn't exist for RAID arrays without redundancy
> so sysfs_read fails if this information is requested. Set options
> according to the device using information from /proc/mdstat.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   Monitor.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Applied!

Thanks,
Jes

