From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 1/2] md: release allocated bitset sync_set
Date: Fri, 10 Nov 2017 11:03:14 +0100
Message-ID: <ebbcc070-bbac-b0a6-660b-4592656440f8@redhat.com>
References: <cover.1510144853.git.zkabelac@redhat.com>
 <83671199e7b9095fece2671521b7a34ad5d92b0a.1510144853.git.zkabelac@redhat.com>
 <20171109233206.hp6o57u5gkwbjlu4@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171109233206.hp6o57u5gkwbjlu4@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 10.11.2017 v 00:32 Shaohua Li napsal(a):
> On Wed, Nov 08, 2017 at 01:44:55PM +0100, Zdenek Kabelac wrote:
>> Patch fixes kmemleak on md_stop() path used likely only by dm-raid
>> wrapper. Code of md is using  mddev_put() where both  bitsets
>> are released however this bitmap freeing is not shared.
> 
> what did you mean 'bitmap freeing is not shared' ? The patch doesn't handle
> bitmap either.
> 

It only means there is some code to teardown md device which is not shared
between 'md'  and  'dm' wrapper - thus whenever mddev_put() is updated
in some way (adding freeing another object)  same code should be
duplicated into  md_stop()  which is used only by 'dm' (from my
understanding of comment in the source).

IMHO this is not ideal - the code for freeing resources should be sharing more 
code lines...

But as of now - patch works and does exactly what is needed...

>> Also set NULL to bio_set and sync_set pointers just like mddev_put is
>> doing.
>>
>> Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
>> ---
>>   drivers/md/md.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 0ff1bbf6c90e..635ad7c38f67 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5834,8 +5834,14 @@ void md_stop(struct mddev *mddev)
>>   	 * This is called from dm-raid
>>   	 */
>>   	__md_stop(mddev);
>> -	if (mddev->bio_set)
>> +	if (mddev->bio_set) {
>>   		bioset_free(mddev->bio_set);
>> +		mddev->bio_set = NULL;
>> +	}
>> +	if (mddev->sync_set) {
>> +		bioset_free(mddev->sync_set);
>> +		mddev->sync_set = NULL;
>> +	}
>>   }
>>   
>>   EXPORT_SYMBOL_GPL(md_stop);
>> -- 
>> 2.15.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

