From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH mdadm] Subdevs can't be all missing when create raid
 device
Date: Fri, 26 Jan 2018 13:51:26 -0500
Message-ID: <86b0a965-0a6b-6490-1279-eee6246994f1@gmail.com>
References: <1516956136-4803-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516956136-4803-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/26/2018 03:42 AM, Xiao Ni wrote:
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Create.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Create.c b/Create.c
> index 239545f..50142d8 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -475,6 +475,10 @@ int Create(struct supertype *st, char *mddev,
>  			close(fd);
>  		}
>  	}
> +	if (missing_disks == dnum) {
> +		pr_err("Subdevs can't be all missing\n");
> +		return 1;
> +	}
>  	if (s->raiddisks + s->sparedisks > st->max_devs) {
>  		pr_err("Too many devices: %s metadata only supports %d\n",
>  			st->ss->name, st->max_devs);
> 

Applied!

Thanks,
Jes

PS: This looks like a great candidate for a unit test :)

