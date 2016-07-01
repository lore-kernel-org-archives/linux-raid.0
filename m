From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RESEND PATCH 2/3] bcache: update document info
Date: Fri, 1 Jul 2016 09:51:32 +0800
Message-ID: <5775CCA4.9070805@huawei.com>
References: <1466561534-17595-1-git-send-email-wangyijing@huawei.com>
 <b66c1795-3201-e571-75da-979893338d85@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <b66c1795-3201-e571-75da-979893338d85@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
To: Coly Li <i@coly.li>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi Coly, thanks to your review and comments.

Commit 77b5a08427e875 ("bcache: don't embed 'return' statements in clos=
ure macros")
remove the return in continue_at(), so I think we should update the doc=
ument info
about continue_at().

Thanks!
Yijing.

=D4=DA 2016/6/29 18:16, Coly Li =D0=B4=B5=C0:
> =D4=DA 16/6/22 =C9=CF=CE=E710:12, Yijing Wang =D0=B4=B5=C0:
>> There is no return in continue_at(), update the documentation.
>>
>=20
> There are 2 modification of this patch. The first one is about a typo=
,
> it is correct.
>=20
> But I doubt your second modification is proper. The line removed in y=
our
> patch is,
>> - * continue_at() also, critically, is a macro that returns the
> calling function.
>> - * There's good reason for this.
>> - *
>=20
> I think this is exactly what original author wants to say. It does no=
t
> mean return a value, it means return to the calling function. And the
> bellowed lines explains the reason.
>=20
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/closure.c |    2 +-
>>  drivers/md/bcache/closure.h |    3 ---
>>  2 files changed, 1 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure=
=2Ec
>> index 9eaf1d6..864e673 100644
>> --- a/drivers/md/bcache/closure.c
>> +++ b/drivers/md/bcache/closure.c
>> @@ -112,7 +112,7 @@ bool closure_wait(struct closure_waitlist *waitl=
ist, struct closure *cl)
>>  EXPORT_SYMBOL(closure_wait);
>> =20
>>  /**
>> - * closure_sync - sleep until a closure a closure has nothing left =
to wait on
>> + * closure_sync - sleep until a closure has nothing left to wait on
>=20
> Yes, this modification is good.
>=20
>>   *
>>   * Sleeps until the refcount hits 1 - the thread that's running the=
 closure owns
>>   * the last refcount.
>> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure=
=2Eh
>> index 782cc2c..f51188d 100644
>> --- a/drivers/md/bcache/closure.h
>> +++ b/drivers/md/bcache/closure.h
>> @@ -31,9 +31,6 @@
>>   * passing it, as you might expect, the function to run when nothin=
g is pending
>>   * and the workqueue to run that function out of.
>>   *
>> - * continue_at() also, critically, is a macro that returns the call=
ing function.
>> - * There's good reason for this.
>> - *
>>   * To use safely closures asynchronously, they must always have a r=
efcount while
>>   * they are running owned by the thread that is running them. Other=
wise, suppose
>>   * you submit some bios and wish to have a function run when they a=
ll complete:
>>
>=20
>=20
