From: Coly Li <colyli@suse.de>
Subject: Re: [RESEND PATCH 2/3] bcache: update document info
Date: Fri, 1 Jul 2016 12:21:43 +0800
Message-ID: <e57c4b4d-cc9f-3ad3-0b2d-d08a4e93cc2a@suse.de>
References: <1466561534-17595-1-git-send-email-wangyijing@huawei.com>
 <b66c1795-3201-e571-75da-979893338d85@coly.li> <5775CCA4.9070805@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5775CCA4.9070805@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>, Coly Li <i@coly.li>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

=D4=DA 16/7/1 =C9=CF=CE=E79:51, wangyijing =D0=B4=B5=C0:
> Hi Coly, thanks to your review and comments.
>=20
> Commit 77b5a08427e875 ("bcache: don't embed 'return' statements in cl=
osure macros")
> remove the return in continue_at(), so I think we should update the d=
ocument info
> about continue_at().
>=20
> Thanks!
> Yijing.

Hi Yijing,

The original version of continue_at() returns to caller function inside
the macro, Jens thinks this macro breaks code execution flow implicitly=
,
so he moves 'return' out of continue_at() and to follow continue_at() a=
t
the location where continue_at() is referenced.

So as I suggested, the original author means the code should return to
the calling function.

But YES, I agree that the comments should be updated, because there is
no 'return' inside macro continue_at(). We should explicitly point out
that there should be a 'return' immediately following macro continue_at=
().

Thanks.

Coly


> =D4=DA 2016/6/29 18:16, Coly Li =D0=B4=B5=C0:
>> =D4=DA 16/6/22 =C9=CF=CE=E710:12, Yijing Wang =D0=B4=B5=C0:
>>> There is no return in continue_at(), update the documentation.
>>>
>>
>> There are 2 modification of this patch. The first one is about a typ=
o,
>> it is correct.
>>
>> But I doubt your second modification is proper. The line removed in =
your
>> patch is,
>>> - * continue_at() also, critically, is a macro that returns the
>> calling function.
>>> - * There's good reason for this.
>>> - *
>>
>> I think this is exactly what original author wants to say. It does n=
ot
>> mean return a value, it means return to the calling function. And th=
e
>> bellowed lines explains the reason.
>>
>>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>> ---
>>>  drivers/md/bcache/closure.c |    2 +-
>>>  drivers/md/bcache/closure.h |    3 ---
>>>  2 files changed, 1 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closur=
e.c
>>> index 9eaf1d6..864e673 100644
>>> --- a/drivers/md/bcache/closure.c
>>> +++ b/drivers/md/bcache/closure.c
>>> @@ -112,7 +112,7 @@ bool closure_wait(struct closure_waitlist *wait=
list, struct closure *cl)
>>>  EXPORT_SYMBOL(closure_wait);
>>> =20
>>>  /**
>>> - * closure_sync - sleep until a closure a closure has nothing left=
 to wait on
>>> + * closure_sync - sleep until a closure has nothing left to wait o=
n
>>
>> Yes, this modification is good.
>>
>>>   *
>>>   * Sleeps until the refcount hits 1 - the thread that's running th=
e closure owns
>>>   * the last refcount.
>>> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closur=
e.h
>>> index 782cc2c..f51188d 100644
>>> --- a/drivers/md/bcache/closure.h
>>> +++ b/drivers/md/bcache/closure.h
>>> @@ -31,9 +31,6 @@
>>>   * passing it, as you might expect, the function to run when nothi=
ng is pending
>>>   * and the workqueue to run that function out of.
>>>   *
>>> - * continue_at() also, critically, is a macro that returns the cal=
ling function.
>>> - * There's good reason for this.
>>> - *
>>>   * To use safely closures asynchronously, they must always have a =
refcount while
>>>   * they are running owned by the thread that is running them. Othe=
rwise, suppose
>>>   * you submit some bios and wish to have a function run when they =
all complete:
>>>
>>
>>
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
