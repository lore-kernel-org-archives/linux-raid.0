From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: [PATCH] mdadm: replace hard coded string length
Date: Fri, 16 Sep 2016 09:34:32 +1000
Message-ID: <4115566d-9994-b90a-12cb-83e54c01baba@websitemanagers.com.au>
References: <1473898407-3049094-1-git-send-email-songliubraving@fb.com>
 <wrfjr38lxhp9.fsf@redhat.com> <5328253.xG1N6xNRzL@natasha>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5328253.xG1N6xNRzL@natasha>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/09/16 04:10, Thomas Fjellstrom wrote:
> On Thursday, September 15, 2016 12:15:30 PM MDT Jes Sorensen wrote:
>> Song Liu <songliubraving@fb.com> writes:
>>> This patch replaces hard coded 32 with sizeof(sb->set_name) in a
>>> couple places.
>>>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>>
>>>   super1.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 9f62d23..7d03b1f 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -1030,7 +1030,7 @@ static void getinfo_super1(struct supertype *st,
>>> struct mdinfo *info, char *map)>
>>>   	memcpy(info->uuid, sb->set_uuid, 16);
>>>
>>> -	strncpy(info->name, sb->set_name, 32);
>>> +	strncpy(info->name, sb->set_name, sizeof(sb->set_name));
>>>
>>>   	info->name[32] = 0;
>>>   	
>>>   	if ((__le32_to_cpu(sb->feature_map)&MD_FEATURE_REPLACEMENT)) {
>>>
>>> @@ -1124,7 +1124,7 @@ static int update_super1(struct supertype *st,
>>> struct mdinfo *info,>
>>>   		if (c)
>>>   		
>>>   			strncpy(info->name, c+1, 31 - (c-sb->set_name));
>>>   		
>>>   		else
>>>
>>> -			strncpy(info->name, sb->set_name, 32);
>>> +			strncpy(info->name, sb->set_name, sizeof(sb->set_name));
>>>
>>>   		info->name[32] = 0;
>>>   	
>>>   	}
>> I was about to apply this, but this is actually wrong. You need to use
>> the size of the destination, not of the source as the limit.
>>
>> Sorry for the hassle.
> I'm not aware of the full details, but either they are the same size, or they
> aren't, and you need to use the minimum size of both to avoid any kind of
> overflow (source or dest, read and write). I presume the destination is
> smaller?
I'm not a programmer, but I think the size of the source is irrelevant. 
If the source is 10 bytes, you can safely copy that to a destination of 
30 bytes. The only problem is if the source content is bigger than the 
destination. Hence, you should copy only based on the destination size.

I'm not sure, but it may be a good idea to confirm that all of the 
source content has been copied, or else there may be unexpected results 
when operating on a truncated value.
I'm sure someone else who is an actual programmer can jump in and advise...

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
