From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH -v4 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Mon, 28 Aug 2017 17:19:22 -0400
Message-ID: <b2d5bab8-94a5-9045-5734-b27e27c4f1fd@gmail.com>
References: <1500537533-8470-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500537533-8470-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2017 03:58 AM, Xiao Ni wrote:
> This case tries to allow raid5 reshape to use backwards direction.
> It changes chunksize after reshape and stops the raid. Then starts
> the raid again.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Suggested-by:  Jes Sorensen <jes.sorensen@gmail.com>
> Suggested-by:  Zhilong Liu <zlliu@suse.com>
> Suggested-by:  Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>   test           |  7 +++++++
>   tests/02r5grow | 17 +++++++++++++++++
>   2 files changed, 24 insertions(+)
> 
> diff --git a/test b/test
> index 87e2df2..98e2981 100755
> --- a/test
> +++ b/test
> @@ -320,6 +320,13 @@ check() {
>   		grep -sq "inactive" /proc/mdstat ||
>   			die "array is not inactive!"
>   		;;
> +	# It only can be used when there is only one raid
> +	chunk )
> +		chunk_size=`awk -F',' '/chunk/{print $2}' /proc/mdstat | awk -F'[a-z]' '{print $1}'`
> +		if [ "$chunk_size" -ne "$2" ] ; then
> +			die "chunksize should be $2, but it's $chunk_size"
> +		fi
> +		;;
>   	* )
>   		die "unknown check $1"
>   		;;
> diff --git a/tests/02r5grow b/tests/02r5grow
> index 386e82e..ea3101b 100644
> --- a/tests/02r5grow
> +++ b/tests/02r5grow
> @@ -34,3 +34,20 @@ check nosync
>   sh tests/testdev $md0 3 $[size/2] 128
>   
>   mdadm -S $md0
> +
> +# create a raid5 array and change the chunk
> +mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
> +check wait
> +check state UUU
> +check chunk 32
> +
> +mdadm $md0 --grow --chunk=64
> +check reshape
> +check wait
> +check chunk 64
> +
> +mdadm -S $md0
> +mdadm -As
> +check state UUU
> +check chunk 64
> +mdadm -Ss

Hi Xiao,

I don't like the last part running 'mdadm -As' this will auto-assemble 
any array in the system and you can get a false test failure because it 
will assume the first assembled array is the one you are looking for.

Cheers,
Jes

