From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH v2] mdadm/grow: adding a test to ensure resize was
 required
Date: Thu, 12 Oct 2017 11:25:54 +0800
Message-ID: <c0442d2a-c296-912b-8524-90e3840b4212@suse.com>
References: <1507537274-29350-2-git-send-email-zlliu@suse.com>
 <1507711992-11548-1-git-send-email-zlliu@suse.com>
 <23006.29835.830546.836114@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23006.29835.830546.836114@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/12/2017 03:44 AM, John Stoffel wrote:
>>>>>> "Zhilong" == Zhilong Liu <zlliu@suse.com> writes:
> Zhilong> To fix the commit: 4b74a905a67e
> Zhilong> (mdadm/grow: Component size must be larger than chunk size)
>
> Zhilong> array.level > 1 : against the raids which chunk_size is meaningful.
> s-> size > 0 : ensure that changing component size has required.
> Zhilong> array.chunk_size / 1024 > s->size : ensure component size should
> Zhilong> be always >= current chunk_size when requires resize, otherwise,
> mddev-> pers->resize would be set mddev->dev_sectors as '0'.
>
> Is there any possibility of setting up a test harness that could be
> used to check for problems like this automatically?  Sorta like the
> xfstests that the filesystem people run?

Agree your suggestions, it's still many works to do in our test part, I have
done a little bit, but daily-work always take more time.
mdadm needs many reliable 'unit test cases' to support, I would continue
to do this once I have time.
Against this patch, I would re-draft the test case of 'tests/02r5grow', 
it can
cover to test this scenario.

>
> I don't know if you've seen the discussion (I know Jes has) about
> mdadm --grow allowing you to reduce an array size enough to nuke the
> superblocks, so I wonder if this fix will also apply to that problem?

Sorry for that, I have no memory with this issue. I do appreciate that if
have detail example here.

Thanks,
-Zhilong
>
>
> Zhilong> Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Zhilong> Suggested-by: NeilBrown <neilb@suse.com>
> Zhilong> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> Zhilong> ---
>
> Zhilong> v1: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
>
> Zhilong> changes:
> Zhilong>   correct the test 's->level == UnSet' as 's->size > 0'
>
> Zhilong>  Grow.c | 1 +
> Zhilong>  1 file changed, 1 insertion(+)
>
> Zhilong> diff --git a/Grow.c b/Grow.c
> Zhilong> index 4d79d83..8c2d50c 100644
> Zhilong> --- a/Grow.c
> Zhilong> +++ b/Grow.c
> Zhilong> @@ -1810,6 +1810,7 @@ int Grow_reshape(char *devname, int fd,
> Zhilong>  	}
>   
> Zhilong>  	if (array.level > 1 &&
> Zhilong> +	    s->size > 0 &&
> Zhilong>  	   (array.chunk_size / 1024) > (int)s->size) {
> Zhilong>  		pr_err("component size must be larger than chunk size.\n");
> Zhilong>  		return 1;
> Zhilong> --
> Zhilong> 2.6.6
>
> Zhilong> --
> Zhilong> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> Zhilong> the body of a message to majordomo@vger.kernel.org
> Zhilong> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

