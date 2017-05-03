From: Liuzhilong <zlliu@suse.de>
Subject: Re: [PATCH] change back 0644 permission for Grow.c
Date: Wed, 3 May 2017 11:16:40 +0800
Message-ID: <97f9931d-2af5-fad1-bf3b-ad476b23de72@suse.de>
References: <1493717233-32524-1-git-send-email-zlliu@suse.com>
 <832ae4d1-4127-6b48-06b8-6b709a191b38@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <832ae4d1-4127-6b48-06b8-6b709a191b38@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/02/2017 09:45 PM, Jes Sorensen wrote:
> On 05/02/2017 05:27 AM, Zhilong Liu wrote:
>> Fixes commit:
>> 26714713cd2b ("mdadm: Change timestamps to unsigned data type.")
>>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>  Grow.c | 0
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  mode change 100755 => 100644 Grow.c
>>
>> diff --git a/Grow.c b/Grow.c
>> old mode 100755
>> new mode 100644
>>
>
> Hi Zhilong,
>
> Not quite sure what you expect me to do with this one......
>
> Maybe including the patch would help :)
>

commit: 26714713cd2bad9e0bf7f4669f6cc4659ceaab6c
it changes the permission of Grow.c and mdadm.h from 644 to 755,
the mdadm.h has changed permission back to 644 according to the
commit: 26714713cd2bad9e0bf7f4669f6cc4659ceaab6c from Neil.
Thus I sent this patch to change back 0644 permission for Grow.c.
The source file doesn't need the executable permission.

Thanks,
-Zhilong
> Cheers,
> Jes
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

