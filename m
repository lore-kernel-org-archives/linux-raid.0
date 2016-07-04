From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 2/3] bcache: update document info
Date: Mon, 4 Jul 2016 14:43:05 +0800
Message-ID: <577A0579.2040005@huawei.com>
References: <1467595414-20844-1-git-send-email-wangyijing@huawei.com>
 <489c5709-29d0-077c-d8b7-92f12447fc08@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <489c5709-29d0-077c-d8b7-92f12447fc08@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
To: Coly Li <i@coly.li>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



=D4=DA 2016/7/4 13:49, Coly Li =D0=B4=B5=C0:
> =D4=DA 16/7/4 =C9=CF=CE=E79:23, Yijing Wang =D0=B4=B5=C0:
>> There is no return in continue_at(), update the documentation.
>>
>=20
> Thanks.
>=20
> Acked-by: Coly Li <colyli@suse.de>

Thanks very much!

>=20
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/closure.c |    2 +-
>>  drivers/md/bcache/closure.h |    3 ++-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
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
>>   *
>>   * Sleeps until the refcount hits 1 - the thread that's running the=
 closure owns
>>   * the last refcount.
>> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure=
=2Eh
>> index 782cc2c..9b2fe2d 100644
>> --- a/drivers/md/bcache/closure.h
>> +++ b/drivers/md/bcache/closure.h
>> @@ -31,7 +31,8 @@
>>   * passing it, as you might expect, the function to run when nothin=
g is pending
>>   * and the workqueue to run that function out of.
>>   *
>> - * continue_at() also, critically, is a macro that returns the call=
ing function.
>> + * continue_at() also, critically, requires a 'return' immediately =
following the
>> + * location where this macro is referenced, to return to the callin=
g function.
>>   * There's good reason for this.
>>   *
>>   * To use safely closures asynchronously, they must always have a r=
efcount while
>>
>=20
>=20
