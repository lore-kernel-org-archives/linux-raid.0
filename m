From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH 0/3] mdadm/test: Refactor the codes of 'test' script
Date: Mon, 12 Jun 2017 10:32:00 +0800
Message-ID: <3e74fb16-4405-533d-1ef3-2169f18d0613@suse.com>
References: <1496827888-17118-1-git-send-email-zlliu@suse.com>
 <d92b0a65-198b-3637-83a1-a71b78cdfd43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d92b0a65-198b-3637-83a1-a71b78cdfd43@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/09/2017 11:08 PM, Jes Sorensen wrote:
> On 06/07/2017 05:31 AM, Zhilong Liu wrote:
>> Hi, Jes;
>>    This patchset mainly focus on improving the 'test' script, rip it
>> apart and put it together in a more coherent form.
>>    Over 3 months passed, the RFC patch of improving 'test' hadn't 
>> received
>> any ideas, thus I post this sample version that I have tested many 
>> times.
>>    It's just the beginning to improve the test part of mdadm, any 
>> questions
>> is very welcome.
>>
>>    Sorry for that, I haven't added the function suggested from 
>> Guoqing, cut
>> the words from the email tree of
>> "ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under Linux":
>>
>> Guoqing asked:
>> ...
>> Is current test can run the test for different raid level, say,
>> "./test --raidtype=raid1"
>> could execute all the *r1* tests, does it make sense to do it if we 
>> don't
>> support it now.
>> ...
>>
>>    Just list this suggestion here, waiting for ideas.
>>
>> RFC patch mail-tree:
>> [PATCH RFC] test: revise 'test' and make it easier to understand
>> Acked-by: Neil Brown
>> And suggest to split those changing into smaller patches from Guoqing.
>
> The whole test infrastructure is something I would like to see 
> rewamped and modernized, so you starting to work on this is excellent.
>
> With regard to your question, then having an option to say 'run all 
> raid1 tests' is probably good, we should have that for all raid 
> levels, imsm, and ddf.
>
> I also would like to see a more flexible way to configure the tests, 
> like it should be possible to specify a bunch of physical devices for 
> the tests, instead of relying on loop devices.

I would send another sample version once complete your suggestions. 
Thanks for your ideas.
Welcome various requirements during I'm doing this.

Thanks,
-Zhilong

>
> Cheers,
> Jes
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

