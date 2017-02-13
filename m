From: zhilong <zlliu@suse.com>
Subject: Re: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under
 Linux
Date: Mon, 13 Feb 2017 13:54:34 +0800
Message-ID: <f578e46d-8e76-0335-332b-3d90aa7848cf@suse.com>
References: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
 <58751E90.5090306@gmail.com> <20170111165241.yavdwc57v6yodx7g@kernel.org>
 <b2808c47-5180-818d-87d9-ab28f699234e@gmail.com> <587704FC.6030701@suse.com>
 <4eb83aa0-6245-d499-f18a-e8456aad9f98@gmail.com>
 <6504747e-c49e-dc54-64a6-bce2220daffc@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6504747e-c49e-dc54-64a6-bce2220daffc@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Bruce Dubbs <bruce.dubbs@gmail.com>, "Brown, Neil" <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


On 02/13/2017 01:08 PM, zhilong wrote:
> Hi, Jes;
>
>
> On 01/13/2017 12:41 AM, Jes Sorensen wrote:
>> On 01/11/17 23:24, Guoqing Jiang wrote:
>>>
>>> On 01/12/2017 12:59 AM, Jes Sorensen wrote:
>>>> On 01/11/17 11:52, Shaohua Li wrote:
>>>>> On Tue, Jan 10, 2017 at 11:49:04AM -0600, Bruce Dubbs wrote:
>>>>>> Jes Sorensen wrote:
>>>>>>> I am pleased to announce the availability of
>>>>>>>       mdadm version 4.0
>>>>>>>
>>>>>>> It is available at the usual places:
>>>>>>> http://www.kernel.org/pub/linux/utils/raid/mdadm/
>>>>>>> and via git at
>>>>>>> git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>>>>>>>       http://git.kernel.org/cgit/utils/mdadm/
>>>>>>>
>>>>>>> The update in major version number primarily indicates this is a
>>>>>>> release by it's new maintainer. In addition it contains a large 
>>>>>>> number
>>>>>>> of fixes in particular for IMSM RAID and clustered RAID 
>>>>>>> support.  In
>>>>>>> addition this release includes support for IMSM 4k sector drives,
>>>>>>> failfast and better documentation for journaled RAID.
>>>>>> Thank you for the new release.  Unfortunately I get 9 failures
>>>>>> running the
>>>>>> test suite:
>>>>>>
>>>>>> tests/00raid1...          FAILED
>>>>>> tests/07autoassemble...   FAILED
>>>>>> tests/07changelevels...   FAILED
>>>>>> tests/07revert-grow...    FAILED
>>>>>> tests/07revert-inplace... FAILED
>>>>>> tests/07testreshape5...   FAILED
>>>>>> tests/10ddf-fail-twice... FAILED
>>>>>> tests/20raid5journal...   FAILED
>>>>>> tests/10ddf-incremental-wrong-order...  FAILED
>>>>> Yep, several tests usually fail. It appears some checks aren't always
>>>>> good.  At
>>>>> least the 'check' function for reshape/resync isn't reliable in my
>>>>> test, I saw
>>>>> 07changelevelintr fails frequently.
>>>> That is my experience as well - some of them are affected by the 
>>>> kernel
>>>> version too. We probably need to look into making them more reliable.
>>> If possible, it could be a potential topic for lsf/mm raid 
>>> discussion as
>>> Coly suggested
>>> in previous mail.
>>>
>>> Is current test can run the test for different raid level, say, "./test
>>> --raidtype=raid1" could
>>> execute all the *r1* tests, does it make sense to do it if we don't
>>> support it now.
>> We could have a discussion about this at LSF/MM, if someone is willing
>> to sponsor getting it accepted and we can get the right people there.
>>
>> Note that the test suite also allows you to run all the 01 tests by
>> specifying ./test 01. I do like to see the test suite improved and made
>> more resilient.
> I'm sorry for my late response, I'm just back to work today from 
> vacation. In the past months, I learned and worked for cluster-md 
> feature,
> and I have draft one test suit for cluster-md feature. please refer to 
> https://github.com/zhilongliu/clustermd-autotest
> I'm very willing to do something for improving mdadm testing part, 
> also wanna improve cluster-md test suit, welcome all comments for it.
>
   I would keep making cluster-md test scripts more and more stable, and 
finally apply to integrate into mdadm test part. :-)

Best regards,
-Zhilong
>> Cheers,
>> Jes
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> Thanks very much,
> -Zhilong
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
