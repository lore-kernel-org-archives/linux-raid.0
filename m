From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 06/11] md/r5cache: sysfs entry r5c_journal_mode
Date: Tue, 15 Nov 2016 15:35:03 -0800
Message-ID: <20161115233503.amnrvlwp6cy3nequ@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-7-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-7-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:18PM -0800, Song Liu wrote:
> With write cache, r5c_journal_mode is the knob to switch between
> write-back and write-through.

I'd prefer the name is journal_mode
> Below is an example:
> 
> root@virt-test:~/# cat /sys/block/md0/md/r5c_state
> [write-through] write-back
> root@virt-test:~/# echo write-back > /sys/block/md0/md/r5c_state
> root@virt-test:~/# cat /sys/block/md0/md/r5c_state
this doesn't match the code, please update

> write-through [write-back]
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c       |  1 +
>  drivers/md/raid5.h       |  1 +
>  3 files changed, 62 insertions(+)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 8330053..d2acb69 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -60,6 +60,8 @@ enum r5c_journal_mode {
>  	R5C_JOURNAL_MODE_WRITE_BACK = 1,
>  };
>  
> +static char *r5c_journal_mode_str[] = {"write-through",
> +				       "write-back"};
>  /*
>   * raid5 cache state machine
>   *
> @@ -1602,6 +1604,64 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  }
>  
> +static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf = mddev->private;
> +	int ret;
> +
> +	if (!conf->log)
> +		return 0;
> +
> +	switch (conf->log->r5c_journal_mode) {
> +	case R5C_JOURNAL_MODE_WRITE_THROUGH:
> +		ret = snprintf(page, PAGE_SIZE, "[%s] %s\n",
> +			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
> +			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
Limiting these lines within 80 character width doesn't impact readability

> +		break;
> +	case R5C_JOURNAL_MODE_WRITE_BACK:
> +		ret = snprintf(page, PAGE_SIZE, "%s [%s]\n",
> +			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_THROUGH],
> +			       r5c_journal_mode_str[R5C_JOURNAL_MODE_WRITE_BACK]);
> +		break;
> +	default:
> +		ret = 0;
> +	}
> +	return ret;
> +}
> +
> +static ssize_t r5c_journal_mode_store(struct mddev *mddev,
> +				      const char *page, size_t len)
> +{
> +	struct r5conf *conf = mddev->private;
> +	struct r5l_log *log = conf->log;
> +	int val = -1, i;
> +
> +	if (!log)
> +		return -ENODEV;
> +
> +	for (i = 0; i < sizeof(r5c_journal_mode_str) / sizeof(r5c_journal_mode_str[0]); i++)
use ARRAY_SIZE

Thanks,
Shaohua
