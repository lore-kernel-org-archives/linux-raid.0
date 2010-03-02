From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [mdadm PATCH 1/3] fix gcc warnings about strict-aliasing rules
Date: Tue, 02 Mar 2010 10:40:21 +0300
Message-ID: <4B8CC0E5.4040004@msgid.tls.msk.ru>
References: <20100227135338.GB24207@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100227135338.GB24207@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

Luca Berra wrong:
> Signed-off-by: Luca Berra <bluca@comedia.it>
> ---
>   util.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/util.c b/util.c
> index 68f048d..1def2a0 100644
> --- a/util.c
> +++ b/util.c
> @@ -1160,7 +1160,7 @@ static int get_gpt_last_partition_end(int fd,
> unsigned long long *endofpart)
>       entry_size = __le32_to_cpu(buf[GPT_ENTRY_SIZE_OFFSET]);
>         /* Check GPT signature*/
> -    if (*((__u64*)buf) != GPT_SIGNATURE_MAGIC)
> +    if ((__u64)buf[0] != GPT_SIGNATURE_MAGIC)

This looks wrong.

buf is an array of unsigned char.  Before, we converted the
whole thing to a pointer to u64 and took the first element
at that address, u64 size.  Now after the change, we take
first _byte_ of the array, convert it to u64 (adding leading
zeros) and compare with a large number.

Does it actually work?

>           return -1;
>         /* sanity checks */
> @@ -1178,7 +1178,7 @@ static int get_gpt_last_partition_end(int fd,
> unsigned long long *endofpart)
>           /* is this valid partition? */
>           if (memcmp(part->type_guid, empty_gpt_entry, 16) != 0) {
>               /* check the last lba for the current partition */
> -            curr_part_end = __le64_to_cpu(*(__u64*)part->ending_lba);
> +            curr_part_end = __le64_to_cpu((__u64)part->ending_lba[0]);

And the same thing here as well.

Thanks!

/mjt

>               if (curr_part_end > *endofpart)
>                   *endofpart = curr_part_end;
>           }

