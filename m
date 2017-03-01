From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 00/14] the latest changes for md-cluster
Date: Wed, 1 Mar 2017 11:50:25 +0800
Message-ID: <58B64501.2000309@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <20170228192721.3jxfigqeqbhhmxca@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228192721.3jxfigqeqbhhmxca@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de, zhilong <zlliu@suse.com>
List-Id: linux-raid.ids



On 03/01/2017 03:27 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:10AM +0800, Guoqing Jiang wrote:
>> Hi,
>>
>> This patchset is based on md/for-next branch, which includes below parts:
>>
>> 1. some code improvements (0001-0004).
>> 2. changes for use sync way to handle METADATA_UPDATED msg (0005-0009).
>> 3. add resize support for md-cluster (0010-0012 and 0014), and also
>>     make some related changes inside md (0013).
> Applied patch 2, 3, 13. Replied to other patches.

Thanks for review.

> BTW, is it possible you can create a test suite people can verify the md-cluster stuff?

Actually, Zhilong is currently working on this, we will push the test
suite into mdadm/test and also improve current test too (you may
see his effort in the list).

Thanks,
Guoqing
