From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] Get failed disk count from array state
Date: Mon, 5 Jun 2017 11:12:07 -0400
Message-ID: <916b7750-adb1-3382-5f58-336616dbe857@gmail.com>
References: <bc4470f4-20bf-c45a-9d96-385e4b46e1e3@gmail.com>
 <1496227617-25207-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496227617-25207-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/31/2017 06:46 AM, Tomasz Majchrzak wrote:
> Recent commit has changed the way failed disks are counted. It breaks
> recovery for external metadata arrays as failed disks are not part of
> the array and have no corresponding entries is sysfs (they are only
> reported for containers) so degraded arrays show no failed disks.
> 
> Recent commit overwrites GET_DEGRADED result prior to GET_STATE and it
> is not set again if GET_STATE has not been requested. As GET_STATE
> provides the same information as GET_DEGRADED, the latter is not needed
> anymore. Remove GET_DEGRADED option and replace it with GET_STATE
> option.
> 
> Don't count number of failed disks looking at sysfs entries but
> calculate it at the end. Do it only for arrays as containers report
> no disks, just spares.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Incremental.c | 14 ++++----------
>   Monitor.c     |  4 ++--
>   managemon.c   |  4 ++--
>   mdadm.h       |  1 -
>   raid6check.c  |  2 +-
>   sysfs.c       | 18 ++++++++----------
>   6 files changed, 17 insertions(+), 26 deletions(-)
> 
> v2:
>    adapted to apply to latest upstream version

Applied!

Thanks,
Jes

