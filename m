From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm -Db switches array to write-pending?!
Date: Fri, 26 Jul 2013 20:01:54 +0200
Message-ID: <51F2B992.60203@arcor.de>
References: <51DD9FC1.2060200@arcor.de> <20130715151809.5fea8c78@notabene.brown> <51E6FC4D.6080309@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51E6FC4D.6080309@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 07/17/2013 10:19 PM, Martin Wilck wrote:
> On 07/15/2013 07:18 AM, NeilBrown wrote:
> 
>> Probably the  best thing to do is:
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index d059af5..b19a1c8 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5629,10 +5629,7 @@ static int get_bitmap_file(struct mddev * mddev, void __user * arg)
>>  	char *ptr, *buf = NULL;
>>  	int err = -ENOMEM;
>>  
>> -	if (md_allow_write(mddev))
>> -		file = kmalloc(sizeof(*file), GFP_NOIO);
>> -	else
>> -		file = kmalloc(sizeof(*file), GFP_KERNEL);
>> +	file = kmalloc(sizeof(*file), GFP_NOIO);
>>  
>>  	if (!file)
>>  		goto out;
>>
>>
>> A failure here is not likely and not catastrophic.
>>
>> Does it fix the situation for you?
> 
> Yes it does.
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Any particular reason why you haven't applied this patch in your git
tree http://git.neil.brown.name/?p=md.git;a=summary yet?

Martin

