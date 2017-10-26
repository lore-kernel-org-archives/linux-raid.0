From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] mdadm/mdopen: check system("modprobe ...") return
Date: Thu, 26 Oct 2017 10:47:52 +0800
Message-ID: <b81c490a-d0ae-9533-48f4-724a9586c29d@suse.com>
References: <f1f0eba1-d5d6-b128-5fa5-8531f5ea984a@digitalgarden.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1f0eba1-d5d6-b128-5fa5-8531f5ea984a@digitalgarden.no>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Berg <erik.berg@digitalgarden.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/25/2017 06:35 PM, Erik Berg wrote:
> Build system gives an error with warn_unused_result, this should fix
> that.

Hi, Erik;
    According to some suggestions from Neil Brown, I have sent the patch 
in 16th Oct.
please refer to the mail:
[PATCH] mdadm/mdopen: create new function create_named_array for writing 
to new_array


Thanks,
-Zhilong
> ---
>   mdopen.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mdopen.c b/mdopen.c
> index dcdc6f2..8cd8507 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -313,7 +313,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>   			udev_block(devnm);
>   		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>   		if (fd < 0 && errno == ENOENT) {
> -			system("modprobe md_mod");
> +			if(system("modprobe md_mod")) {
> +				pr_err("check modprobe md_mod results\n");
> +				return -1;
> +			}
>   			fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>   		}
>   		if (fd >= 0) {

