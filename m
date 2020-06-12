From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Use more secure HTTPS URLs
Date: Fri, 12 Jun 2020 10:50:45 -0400
Message-ID: <575ffb80-8a26-8b03-4036-4f1b5bc91649@trained-monkey.org>
References: <20200528145224.19062-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200528145224.19062-1-pmenzel@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/28/20 10:52 AM, Paul Menzel wrote:
> All URLs in the source are available over HTTPS, so convert all URLs to
> HTTPS with the command below.
> 
>     git grep -l 'http://' | xargs sed -i 's,http://,https://,g'
> 
> Revert the changes to announcement files `ANNOUNCE-*` as requested by
> the maintainer.
> 
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>  external-reshape-design.txt      | 2 +-
>  mdadm.8.in                       | 6 +++---
>  mdadm.spec                       | 4 ++--
>  raid6check.8                     | 2 +-
>  restripe.c                       | 2 +-
>  udev-md-raid-safe-timeouts.rules | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
I applied this and then applied a follow-on patch to fix the Intel link
to the one Mariusz provided.

Thanks,
Jes
