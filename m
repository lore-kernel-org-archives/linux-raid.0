From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: use rounded size for metadata initialization
Date: Thu, 30 Mar 2017 11:55:15 -0400
Message-ID: <3db414f3-41c1-ecdf-e01b-131d00e74a6f@gmail.com>
References: <1490883941-31953-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490883941-31953-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2017 10:25 AM, Tomasz Majchrzak wrote:
> Array size is rounded to the nearest MB, however number of data stripes
> and blocks per disk are calculated using size passed by the user. If
> given size is not aligned, there is a mismatch. It's not possible to
> assemble raid0 migrated to raid5 since raid5 arrays use number of data
> stripes to calculate array size.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 52 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 18 deletions(-)

Applied!

Thanks,
Jes


