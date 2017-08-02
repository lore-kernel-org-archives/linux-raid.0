From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v4] mdadm/r5cache: allow adding journal to array without
 journal
Date: Wed, 2 Aug 2017 09:25:44 -0400
Message-ID: <86075ebe-65d7-1b49-2dce-bc674d1f6ceb@gmail.com>
References: <20170328180444.3385563-1-songliubraving@fb.com>
 <wrfjzig5fetg.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzig5fetg.fsf@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, Kernel Team <kernel-team@fb.com>, schmidt@digadd.de
List-Id: linux-raid.ids

On 03/28/2017 02:15 PM, jes.sorensen@gmail.com wrote:
> Song Liu <songliubraving@fb.com> writes:
>> Currently, --add-journal can be only used to recreate broken journal
>> for arrays with journal since  creation. As the kernel code getting
>> more mature, this constraint is no longer necessary.
>>
>> This patch allows --add-journal to add journal to array without
>> journal.
>>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>   Manage.c   | 6 ------
>>   mdadm.8.in | 5 ++---
>>   2 files changed, 2 insertions(+), 9 deletions(-)
> 
> Applied!

It was pointed out to me that this patch never showed up in git.

After digging through my git tree a bit, I see no sign of having applied 
it :( Well it's in there now, apologies.

Kudos to Christian Schmidt for pointing this out.

Cheers,
Jes
