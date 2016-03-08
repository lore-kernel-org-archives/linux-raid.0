From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 2/2] Remove dead code about LKF_CONVERT flag
Date: Tue, 8 Mar 2016 09:28:18 +0800
Message-ID: <56DE2AB2.3020604@suse.com>
References: <1457343063-14884-1-git-send-email-gqjiang@suse.com>
 <1457343063-14884-2-git-send-email-gqjiang@suse.com>
 <wrfjio0yj9fq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjio0yj9fq.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/08/2016 04:54 AM, Jes Sorensen wrote:
> Guoqing Jiang <gqjiang@suse.com> writes:
>> Since flags is only set as LKF_NOQUEUE, the code
>> with LKF_CONVERT flag should be delete.
>>
>> Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   mdadm.h | 1 -
>>   util.c  | 8 --------
>>   2 files changed, 9 deletions(-)
> Applied!
>
> For multi-patch series, would you mind adding a cover letter when you
> post them? Then I can just respond to that if all patches are applied.

Sorry for inconvenience, I will do it in next time for similar case.

Thanks,
Guoqing

