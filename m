From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Assemble.c: respect force flag.
Date: Tue, 5 May 2020 14:02:41 -0400
Message-ID: <2f0b5405-eacd-afc9-69ab-3ffa781045ba@trained-monkey.org>
References: <20200505101717.29553-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200505101717.29553-1-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/5/20 6:17 AM, Tkaczyk Mariusz wrote:
> From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> 
> If the array is dirty handler will set resync_start to 0 to inform kernel
> that resync is needed. RWH affects only raid456 module, for other
> levels array will be started even array is degraded and resync cannot be
> performed.
> 
> Force is really meaningful for raid456. If array is degraded and resync
> is requested, kernel will reject an attempt to start the array. To
> respect force, it has to be marked as clean (this will be done for each
> array without PPL) and remove the resync request (only for raid 456).
> Data corruption may occur so proper warning is added.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  Assemble.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 13 deletions(-)

Applied!

Thanks,
Jes
