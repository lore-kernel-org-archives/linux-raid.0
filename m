From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] drivers/md.c: Make bio_alloc_mddev return
 bio_alloc_bioset
Date: Mon, 14 Jan 2019 06:33:06 -0700
Message-ID: <7799ad39-06e1-bbaa-fa7a-60fecb48da21@kernel.dk>
References: <20181222100845.566772-1-marcos.souza.org@gmail.com>
 <20190111021740.GB1228567@bebop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111021740.GB1228567@bebop>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, linux-kernel@vger.kernel.org
Cc: shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/10/19 7:17 PM, Marcos Paulo de Souza wrote:
> ping?
> 
> On Sat, Dec 22, 2018 at 08:08:45AM -0200, Marcos Paulo de Souza wrote:
>> bio_alloc_bioset return a bio pointer or NULL, so we can avoid storing
>> the returned data into a new variable.
>>
>> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
>> ---
>>  drivers/md/md.c | 7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index fc488cb30a94..42e018f014cb 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -207,15 +207,10 @@ static bool create_on_open = true;
>>  struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>>  			    struct mddev *mddev)
>>  {
>> -	struct bio *b;
>> -
>>  	if (!mddev || !bioset_initialized(&mddev->bio_set))
>>  		return bio_alloc(gfp_mask, nr_iovecs);
>>  
>> -	b = bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
>> -	if (!b)
>> -		return NULL;
>> -	return b;
>> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
>>  }
>>  EXPORT_SYMBOL_GPL(bio_alloc_mddev);

Applied, thanks.

-- 
Jens Axboe
