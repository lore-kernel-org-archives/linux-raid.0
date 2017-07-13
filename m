From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Thu, 13 Jul 2017 10:27:11 -0400
Message-ID: <6a8862cb-8ca3-ccc9-54f7-f3a99bb436a8@gmail.com>
References: <1499937259-16791-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1499937259-16791-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

On 07/13/2017 05:14 AM, Xiao Ni wrote:
> This case trys to allow raid5 reshape to use backwards direction.
> It changes chunksize after reshape and stop the raid. Then start
> the raid again.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   tests/02r5grow | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/tests/02r5grow b/tests/02r5grow
> index 386e82e..14d05d6 100644
> --- a/tests/02r5grow
> +++ b/tests/02r5grow
> @@ -34,3 +34,15 @@ check nosync
>   sh tests/testdev $md0 3 $[size/2] 128
>   
>   mdadm -S $md0
> +
> +# create a raid5 array and change the chunk
> +mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
> +check wait
> +check state UUU
> +
> +mdadm $md0 --grow --chunk=64
> +mdadm --wait $md0

You are not checking the outcome of your chunk change operation. Running 
a test and not making sure it succeeds kinda makes it useless.

Cheers,
Jes


> +
> +mdadm -S $md0
> +mdadm -As
> +mdadm -Ss
> 

