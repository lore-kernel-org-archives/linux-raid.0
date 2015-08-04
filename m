From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 2/2] Make cmap_* also has same policy as dlm_*
Date: Tue, 04 Aug 2015 18:09:19 +0800
Message-ID: <55C08F4F.7070806@suse.com>
References: <1438601519-17919-1-git-send-email-gqjiang@suse.com> <1438601519-17919-2-git-send-email-gqjiang@suse.com> <55BF5766.9070008@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55BF5766.9070008@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,

Goldwyn Rodrigues wrote:
> On 08/03/2015 06:31 AM, Guoqing Jiang wrote:
>> Let libcmap lib and related funs also only need one-time
>> setup during mdadm running period.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   mdadm.c | 23 +++++++++++--------
>>   mdadm.h | 20 ++++++++++++++++
>>   util.c  | 81
>> +++++++++++++++++++++++++++++++++++++++--------------------------
>>   3 files changed, 82 insertions(+), 42 deletions(-)
>>
[snip]
>> +
>> +void set_hookers(void)
>> +{
>> +    set_dlm_hookers();
>> +    set_cmap_hookers();
>> +}
>> +
>> +void free_hookers(void)
>> +{
>> +    free_dlm_hookers();
>> +    free_cmap_hookers();
>> +}
>>
>
> You could put both functions in a single structure called cluster_hooks.
>
Yes, it could be. If there more libs are needed in future, so I prefer
separate them according to different libraries.

Thanks,
Guoqing
