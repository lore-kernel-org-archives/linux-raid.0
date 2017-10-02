From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [MDADM PATCH 1/2] Close mdfd before returning main function
Date: Mon, 2 Oct 2017 13:27:23 -0400
Message-ID: <0082c26c-d97f-d2a9-6596-3f819c3366a8@gmail.com>
References: <1505801207-10096-1-git-send-email-xni@redhat.com>
 <1505801207-10096-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1505801207-10096-2-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

On 09/19/2017 02:06 AM, Xiao Ni wrote:
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   mdadm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mdadm.c b/mdadm.c
> index d80aab3..7cdcdba 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1734,6 +1734,8 @@ int main(int argc, char *argv[])
>   		autodetect();
>   		break;
>   	}
> +	if (mdfd > 0)
> +		close(mdfd);
>   	exit(rv);
>   }

While technically not necessary, since exit() will result in file 
descriptors for the process getting closed, I do prefer to have the code 
clean up properly after itself. I have gone ahead and applied this one.

Cheers,
Jes


