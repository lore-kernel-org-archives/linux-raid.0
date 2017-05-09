From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 0/5] Don't combine disks with different sector size in the
 array
Date: Tue, 9 May 2017 14:18:54 -0400
Message-ID: <e972c34e-5a78-93d2-06b4-3d870550fb43@gmail.com>
References: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/09/2017 06:25 AM, Tomasz Majchrzak wrote:
> IMSM doesn't allow to create arrays including drives with different sector
> sizes.
> 
> Following patchset blocks all paths to create such configuration:
>   * explicit array create
>   * array rebuild (spare in the same container, spare moved across containers)
>   * array grow
> 
> Alexey Obitotskiy (5):
>    imsm: allow drives in a container regardless of sector size
>    imsm: allocate buffer to support maximum sector size
>    imsm: don't allow disks with different sector size in one array
>    Allow more spare selection criteria
>    Add sector size as spare selection criterion
> 
>   Incremental.c | 18 ++++++++-----
>   Monitor.c     | 38 ++++++++++++++++----------
>   mdadm.h       | 19 +++++++++----
>   super-intel.c | 86 ++++++++++++++++++++++++++++++++++++++++-------------------
>   util.c        | 37 ++++++++++++++++++++++---
>   5 files changed, 140 insertions(+), 58 deletions(-)
> 

Applied!

Thanks,
Jes

