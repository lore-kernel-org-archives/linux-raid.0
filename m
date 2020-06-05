From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Use more secure HTTPS URLs
Date: Fri, 5 Jun 2020 11:17:15 -0400
Message-ID: <8b02033d-7570-e654-dc18-a96f0a71d00c@trained-monkey.org>
References: <20200528145224.19062-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200528145224.19062-1-pmenzel@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>, Kinga Tanska <kinga.tanska@intel.com>
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
> 
> diff --git a/external-reshape-design.txt b/external-reshape-design.txt
> index 10c57cc..e4cf4e1 100644
> --- a/external-reshape-design.txt
> +++ b/external-reshape-design.txt
> @@ -277,4 +277,4 @@ sync_action
>  
>  ...
>  
> -[1]: Linux kernel design patterns - part 3, Neil Brown http://lwn.net/Articles/336262/
> +[1]: Linux kernel design patterns - part 3, Neil Brown https://lwn.net/Articles/336262/
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 9e7cb96..7f32762 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -367,7 +367,7 @@ Use the Intel(R) Matrix Storage Manager metadata format.  This creates a
>  which is managed in a similar manner to DDF, and is supported by an
>  option-rom on some platforms:
>  .IP
> -.B http://www.intel.com/design/chipsets/matrixstorage_sb.htm
> +.B https://www.intel.com/design/chipsets/matrixstorage_sb.htm

Sorry for being a pain, but this link isn't actually valid.

Does someone from Intel know what to point at?

Cheers,
Jes
