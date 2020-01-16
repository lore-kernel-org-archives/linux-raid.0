From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Add support for Tebibytes
Date: Thu, 16 Jan 2020 13:55:24 -0500
Message-ID: <fe41804e-fded-7a7d-bbc8-426f0123f97a@trained-monkey.org>
References: <20200110111046.1802-1-kinga.tanska@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200110111046.1802-1-kinga.tanska@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/10/20 6:10 AM, Kinga Tanska wrote:
> Adding support for Tebibytes enables display size of
> volumes in Tebibytes and Terabytes when they are
> bigger than 2048 GiB (or GB).
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  mdadm.8.in | 20 ++++++++++----------
>  util.c     | 47 +++++++++++++++++++++++++++++++++--------------
>  2 files changed, 43 insertions(+), 24 deletions(-)
> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 9aec9f4..ad7a0aa 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -467,8 +467,8 @@ If this is not specified
>  size, though if there is a variance among the drives of greater than 1%, a warning is
>  issued.
>  
> -A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
> -Gigabytes respectively.
> +A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
> +Megabytes, Gigabytes or Terabytes respectively.
>  
>  Sometimes a replacement drive can be a little smaller than the
>  original drives though this should be minimised by IDEMA standards.
> @@ -534,8 +534,8 @@ problems the array can be made bigger again with no loss with another
>  .B "\-\-grow \-\-array\-size="
>  command.
>  
> -A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
> -Gigabytes respectively.
> +A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
> +Megabytes, Gigabytes or Terabytes respectively.
>  A value of
>  .B max
>  restores the apparent size of the array to be whatever the real
> @@ -553,8 +553,8 @@ This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
>  RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
>  of 2.  In any case it must be a multiple of 4KB.
>  
> -A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
> -Gigabytes respectively.
> +A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
> +Megabytes, Gigabytes or Terabytes respectively.
>  
>  .TP
>  .BR \-\-rounding=
> @@ -741,8 +741,8 @@ When using an
>  bitmap, the chunksize defaults to 64Meg, or larger if necessary to
>  fit the bitmap into the available space.
>  
> -A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
> -Gigabytes respectively.
> +A suffix of 'K', 'M', 'G' or 'T' can be given to indicate Kilobytes,
> +Megabytes, Gigabytes or Terabytes respectively.
>  
>  .TP
>  .BR \-W ", " \-\-write\-mostly
> @@ -831,8 +831,8 @@ an array which was originally created using a different version of
>  which computed a different offset.
>  
>  Setting the offset explicitly over-rides the default.  The value given
> -is in Kilobytes unless a suffix of 'K', 'M' or 'G' is used to explicitly
> -indicate Kilobytes, Megabytes or Gigabytes respectively.
> +is in Kilobytes unless a suffix of 'K', 'M', 'G' or 'T' is used to explicitly
> +indicate Kilobytes, Megabytes, Gigabytes or Terabytes respectively.
>  
>  Since Linux 3.4,
>  .B \-\-data\-offset
> diff --git a/util.c b/util.c
> index 64dd409..1986d9f 100644
> --- a/util.c
> +++ b/util.c
> @@ -389,7 +389,7 @@ int mdadm_version(char *version)
>  unsigned long long parse_size(char *size)
>  {
>  	/* parse 'size' which should be a number optionally
> -	 * followed by 'K', 'M', or 'G'.
> +	 * followed by 'K', 'M'. 'G' or 'T'.
>  	 * Without a suffix, K is assumed.
>  	 * Number returned is in sectors (half-K)
>  	 * INVALID_SECTORS returned on error.
> @@ -411,6 +411,10 @@ unsigned long long parse_size(char *size)
>  			c++;
>  			s *= 1024 * 1024 * 2;
>  			break;
> +		case 'T':
> +			c++;
> +			s *= 1024 * 1024 * 1024 * 2L;

Minor nitpick, I suspect this needs to be 2LL to be consistent with the
rest of the code. In theory there are broken systems out there which
define L as 32 bit.

Cheers,
Jes
