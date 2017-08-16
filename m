From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v3] Monitor: containers don't have the same sysfs
 properties as arrays
Date: Wed, 16 Aug 2017 08:26:45 -0400
Message-ID: <485eaeec-5de4-f4b2-aa5b-199e71cb3eec@gmail.com>
References: <544652f0-97d4-d228-7832-cd0268727433@gmail.com>
 <1502886152-14765-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502886152-14765-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/16/2017 08:22 AM, Mariusz Tkaczyk wrote:
> GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
> this information is requested. Set options according to the device using
> information from /proc/mdstat.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   Monitor.c | 46 ++++++++++++++++++++++++++++------------------
>   1 file changed, 28 insertions(+), 18 deletions(-)

Applied!

Thanks,
Jes


