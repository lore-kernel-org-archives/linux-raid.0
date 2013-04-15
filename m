From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/8] mmc: fix max_discard_sectors
Date: Mon, 15 Apr 2013 16:52:54 +0900
Message-ID: <CAKYAXd8EPHoeKY3GUZof+uzHRQ78EW68DuJfjKx=xXs45uYkOQ@mail.gmail.com>
References: <1365860309-21261-1-git-send-email-linkinjeon@gmail.com>
	<516BAA36.9030500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <516BAA36.9030500-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Vivek Trivedi <t.vivek-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-raid.ids

2013/4/15, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> On 13/04/13 16:38, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>
>> https://lkml.org/lkml/2013/4/1/292
>> As per above discussion, there is possibility that request's __data_len
>> field may overflow when max_discard_sectors greater than UINT_MAX >> 9
>>
>> If multiple discard requests get merged, merged discard request's
>> size exceeds 4GB, there is possibility that merged discard request's
>> __data_len field may overflow.
>>
>> This patch fixes this issue.
>>
>> Reported-by: Max Filippov <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Vivek Trivedi <t.vivek-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Tested-by: Max Filippov <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/mmc/card/queue.c |    2 +-
>>  drivers/mmc/core/core.c  |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
>> index 9447a0e..54726b7 100644
>> --- a/drivers/mmc/card/queue.c
>> +++ b/drivers/mmc/card/queue.c
>> @@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  		return;
>>
>>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>> -	q->limits.max_discard_sectors = max_discard;
>> +	blk_queue_max_discard_sectors(q, max_discard);
>>  	if (card->erased_byte == 0 && !mmc_can_discard(card))
>>  		q->limits.discard_zeroes_data = 1;
>>  	q->limits.discard_granularity = card->pref_erase << 9;
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index 7b435a3..6ee530c 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -2058,7 +2058,7 @@ static unsigned int mmc_do_calc_max_discard(struct
>> mmc_card *card,
>>  	if (card->erase_shift)
>>  		max_qty = UINT_MAX >> card->erase_shift;
>>  	else if (mmc_card_sd(card))
>> -		max_qty = UINT_MAX;
>> +		max_qty = UINT_MAX >> 9;
>
> No.  This function calculates max discard for the card not the block layer.
>  Apply the block layer limitation at the block layer interface e.g.
> in mmc_queue_setup_discard()
Hi Adrian,
Okay, I will remove change in mmc_do_calc_max_discard and mmc_calc_max_discard.

>> @@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  		return;
>>
>>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>> -	q->limits.max_discard_sectors = max_discard;
>> +	blk_queue_max_discard_sectors(q, max_discard);
>>  	if (card->erased_byte == 0 && !mmc_can_discard(card))
>>  		q->limits.discard_zeroes_data = 1;
Above change will handle max discard sectors as we have updated
blk_queue_max_discard_sectors to check upper limit of max discard
sectors as UINT_MAX >> 9.

Thanks.
>
>>  	else
>>  		max_qty = UINT_MAX / card->erase_size;
>>
>> @@ -2100,7 +2100,7 @@ unsigned int mmc_calc_max_discard(struct mmc_card
>> *card)
>>  	unsigned int max_discard, max_trim;
>>
>>  	if (!host->max_discard_to)
>> -		return UINT_MAX;
>> +		return UINT_MAX >> 9;
>
> Ditto.
>
>>
>>  	/*
>>  	 * Without erase_group_def set, MMC erase timeout depends on clock
>>
>
>

------------------------------------------------------------------------------
Precog is a next-generation analytics platform capable of advanced
analytics on semi-structured data. The platform includes APIs for building
apps and a phenomenal toolset for data science. Developers can use
our toolset for easy data analysis & visualization. Get a free account!
http://www2.precog.com/precogplatform/slashdotnewsletter
