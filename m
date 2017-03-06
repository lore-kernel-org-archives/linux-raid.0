From: zhilong <zlliu@suse.com>
Subject: Re: [PATCH RFC] test: revise 'test' and make it easier to understand
Date: Mon, 6 Mar 2017 11:27:53 +0800
Message-ID: <f55bad57-1909-d072-7dea-62ff0ab2679b@suse.com>
References: <a81137d5-3042-e983-fe0e-1b9a0de836ff@suse.com>
 <1488250053-10436-1-git-send-email-zlliu@suse.com> <58B92400.7010800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B92400.7010800@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.de>, neilb@suse.com, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 03/03/2017 04:06 PM, Guoqing Jiang wrote:
>
>
> On 02/28/2017 10:47 AM, Zhilong Liu wrote:
>> 1. use 'Tab' as the code style.
>> 2. arrange the testing steps and provide the 'main' entrance.
>> 3. draft the log_save feature, it captures the /proc/mdstat,
>>     md superblock info, bitmap info and the detail dmesg.
>> 4. modified the mdadm() func, adding the operation that clear
>>     the superblock when create or build one new array, and it
>>     would exit testing when mdadm command returned non-0 value.
>> 5. delete no_errors() func, it only used in tests/04update-uuid,
>>     I recommend the new mdadm() using method.
>> 6. delete fast_sync() func.
>> 7. testdev(), add the object file checking, otherwise this command
>>     would create one regular file, it's one trouble thing.
>> 8. add dmesg checking in do_test() func, it's necessary to check
>>     dmesg whether or not printed abnormal message.
>> 9. add checking conditions in main(), such as $pwd/raid6check need
>>     exists, here is a prompt to remind users to 'make everything'
>>     before testing; the $targetdir should mount under ext[2-4] FS,
>>     because the external bitmap only supports ext, the bmap() API
>>     of bitmap.c doesn't exist in all filesystem, such as btrfs.
>>
>
> I like the improvement for the test, and I would suggest you split
> those changes into smaller patches, make each patch do one thing,
> it would be easier for Jes to review I think, and you still can merge
> them into one finally if Jes prefer one patch with huge changes, :-) .
>

Copy that, really appreciate this nice point.

Thanks,
-Zhilong
> Cheers,
> Guoqing
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

