From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/4] md: fix lockdep warning
Date: Fri, 10 Apr 2020 00:32:43 +0000
Message-ID: <DA29BDF5-4B14-48AF-8B21-3B6A82857B7C@fb.com>
References: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
 <CAPhsuW4rWa_ZCX=3eW9Xk_jtZdu+uKX4HZtbfEJfS9ms4a+OSg@mail.gmail.com>
 <76835eb0-d3a7-c5ea-5245-4dcf21a40f7c@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <76835eb0-d3a7-c5ea-5245-4dcf21a40f7c@cloud.ionos.com>
Content-Language: en-US
Content-ID: <A173C84F8055CD448B938E76DE92EE67@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> On Apr 9, 2020, at 2:47 PM, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>=
 wrote:
>=20
> On 09.04.20 09:25, Song Liu wrote:
>> Thanks for the fix!
>>=20
>> On Sat, Apr 4, 2020 at 3:01 PM Guoqing Jiang
>> <guoqing.jiang@cloud.ionos.com> wrote:
>>> Hi,
>>>=20
>>> After LOCKDEP is enabled, we can see some deadlock issues, this patchse=
t
>>> makes workqueue is flushed only necessary, and the last patch is a clea=
nup.
>>>=20
>>> Thanks,
>>> Guoqing
>>>=20
>>> Guoqing Jiang (5):
>>>   md: add checkings before flush md_misc_wq
>>>   md: add new workqueue for delete rdev
>>>   md: don't flush workqueue unconditionally in md_open
>>>   md: flush md_rdev_misc_wq for HOT_ADD_DISK case
>>>   md: remove the extra line for ->hot_add_disk
>> I think we will need a new workqueue (2/5). But I am not sure about
>> whether we should
>> do 1/5 and 3/5. It feels like we are hiding errors from lock_dep. With
>> some quick grep,
>> I didn't find code pattern like
>>=20
>>        if (work_pending(XXX))
>>                flush_workqueue(XXX);
>=20
> Maybe the way that md uses workqueue is quite different from other subsys=
tems ...
>=20
> Because, this is the safest way to address the issue. Otherwise I suppose=
 we have to
> rearrange the lock order or introduce new lock, either of them is tricky =
and could
> cause regression.
>=20
> Or maybe it is possible to  flush workqueue in md_check_recovery, but I w=
ould prefer
> to make less change to avoid any potential risk.
>=20

Agreed that we should try to avoid risk. Let me think more about this.=20

Thanks,
Song=
