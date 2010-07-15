From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: mdadm "hang", 100% CPU usage when trying to create RAID-1 array
 with external bitmap
Date: Thu, 15 Jul 2010 12:35:39 +0200
Message-ID: <4C3EE47B.5030506@wpkg.org>
References: <4C3D9739.7030703@wpkg.org> <20100715074544.3172df47@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100715074544.3172df47@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15.07.2010 07:45, Neil Brown wrote:

(...)

>> access("/mnt/src/bitmap", F_OK)         = -1 ENOENT (No such file or directory)
>> open("/mnt/src/bitmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 3
>>
>>
>
> Hmm... that's rather embarrassing.
> This patch should fit it.  Or you can explicitly set a bitmap chunk size -
> aim for several megabyte.
>
> Thanks for the report,
> NeilBrown
>
> diff --git a/bitmap.c b/bitmap.c
> index beef2dc..44a8677 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -373,7 +373,7 @@ int CreateBitmap(char *filename, int force, char uuid[16],
>   		 */
>   		chunksize = DEFAULT_BITMAP_CHUNK;
>   		/*<<20 for 2^20 chunks,>>9 to convert bytes to sectors */
> -		while (array_size>  (chunksize<<  (20-9)))
> +		while (array_size>  ((unsigned long long)chunksize<<  (20-9)))

It works fine with that patch applied, thanks a lot!


-- 
Tomasz Chmielewski
http://syneticon.net

