From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 3/4] Detail: ensure --export names are acceptable as
 shell variables.
Date: Thu, 20 Apr 2017 12:59:41 -0400
Message-ID: <181ac33d-7ee3-53fe-e151-b892998b2b7a@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600586.31004.10549541527467125631.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265600586.31004.10549541527467125631.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2017 10:40 PM, NeilBrown wrote:
> If an array contains a device which has a name that
> contains something other than alphnumerics and underscores,
> then some values reported by "mdadm --detail --export" will
> not be valid as variable assignment of the shell.
> This particularly affects dm devices.
> e.g.
>    MD_DEVICE_dm-4_ROLE=1
>    MD_DEVICE_dm-4_DEV=/dev/dm-4
>
> As it is particularly useful to be able to work with these
> in a shell script, and as the precise name is not important,
> change all non-alphanumerics to '_'.
>
>    MD_DEVICE_dm_4_ROLE=1
>    MD_DEVICE_dm_4_DEV=/dev/dm-4
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Detail.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes


