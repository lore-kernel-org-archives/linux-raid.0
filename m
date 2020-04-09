From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH 0/4] md: fix lockdep warning
Date: Thu, 9 Apr 2020 23:47:55 +0200
Message-ID: <76835eb0-d3a7-c5ea-5245-4dcf21a40f7c@cloud.ionos.com>
References: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
 <CAPhsuW4rWa_ZCX=3eW9Xk_jtZdu+uKX4HZtbfEJfS9ms4a+OSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4rWa_ZCX=3eW9Xk_jtZdu+uKX4HZtbfEJfS9ms4a+OSg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09.04.20 09:25, Song Liu wrote:
> Thanks for the fix!
>
> On Sat, Apr 4, 2020 at 3:01 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
>> Hi,
>>
>> After LOCKDEP is enabled, we can see some deadlock issues, this patchset
>> makes workqueue is flushed only necessary, and the last patch is a cleanup.
>>
>> Thanks,
>> Guoqing
>>
>> Guoqing Jiang (5):
>>    md: add checkings before flush md_misc_wq
>>    md: add new workqueue for delete rdev
>>    md: don't flush workqueue unconditionally in md_open
>>    md: flush md_rdev_misc_wq for HOT_ADD_DISK case
>>    md: remove the extra line for ->hot_add_disk
> I think we will need a new workqueue (2/5). But I am not sure about
> whether we should
> do 1/5 and 3/5. It feels like we are hiding errors from lock_dep. With
> some quick grep,
> I didn't find code pattern like
>
>         if (work_pending(XXX))
>                 flush_workqueue(XXX);

Maybe the way that md uses workqueue is quite different from other 
subsystems ...

Because, this is the safest way to address the issue. Otherwise I 
suppose we have to
rearrange the lock order or introduce new lock, either of them is tricky 
and could
cause regression.

Or maybe it is possible to  flush workqueue in md_check_recovery, but I 
would prefer
to make less change to avoid any potential risk.

Thanks,
Guoqing
