From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Monitor: containers don't have the same sysfs properties
 as arrays
Date: Thu, 27 Jul 2017 05:48:55 -0400
Message-ID: <84988083-a146-bba4-bd0e-1736ccbf8347@gmail.com>
References: <1500639337-12816-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500639337-12816-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/21/2017 08:15 AM, Mariusz Tkaczyk wrote:
> GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
> this information is requested. Set options according to the device using
> information from /proc/mdstat.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Monitor.c | 50 ++++++++++++++++++++++++++++----------------------
>   1 file changed, 28 insertions(+), 22 deletions(-)

Hi Mariusz,

Sorry for the late response, I am currently traveling so there have been 
some delays.

I am fine with the principle of this patch, but I have a few nits:

> diff --git a/Monitor.c b/Monitor.c
> index 48c451c..8d753ca 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -459,22 +459,41 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	mdu_array_info_t array;
>   	struct mdstat_ent *mse = NULL, *mse2;
>   	char *dev = st->devname;
> -	int fd;
> +	int fd = -1;
>   	int i;
>   	int remaining_disks;
>   	int last_disk;
>   	int new_array = 0;
> -	int retval;
> +	int retval = 0;
> +	int is_container;
> +	unsigned long array_only_flags = 0;

You initialize array_only_flags here.

[snip]

> @@ -482,11 +501,11 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	if (md_get_array_info(fd, &array) < 0)
>   		goto disappeared;
>   
> -	if (st->devnm[0] == 0)
> -		strcpy(st->devnm, fd2devnm(fd));
> +	array_only_flags |= !is_container ? GET_MISMATCH : 0;
> +

... and again here.

Could we try and avoid that obfuscated approach and simply do

	if (!is_container)
		array_only_flags |= GET_MISMATCH

That would avoid the double initialization and is a lot more readable.

Second issue, you are moving to global initialization for a number of 
variables. That is pretty much always bad as it hides things - please 
avoid that unless absolutely necessary.

Thanks,
Jes
