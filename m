From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH] imsm: continue resync on 3-disk RAID10
Date: Tue, 21 Nov 2017 13:31:52 -0500
Message-ID: <bdd9e417-49f5-d038-be24-1a9b570856e6@fb.com>
References: <20171113113049.23388-1-maksymilian.kunt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171113113049.23388-1-maksymilian.kunt@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Maksymilian Kunt <maksymilian.kunt@intel.com>, linux-raid@vger.kernel.org
Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

On 11/13/2017 06:30 AM, Maksymilian Kunt wrote:
> If RAID10 gets degraded during resync and is stopped, it doesn't continue
> resync after automatic assemble and it is reported to be in sync. Resync
> is blocked because the disk is missing. It should not happen for RAID10 as
> it can still continue with 3 disks.
> 
> Count missing disks. Block resync only if number of missing disks exceeds
> limit for given RAID level (only different for RAID10). Check if the
> disk under recovery is present. If not, resync should be allowed to run.
> 
> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 41 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 8 deletions(-)

Applied!

Thanks,
Jes


