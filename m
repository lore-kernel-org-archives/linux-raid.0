From: jes.sorensen@gmail.com
Subject: Re: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Wed, 05 Apr 2017 11:37:30 -0400
Message-ID: <wrfjh922euh1.fsf@gmail.com>
References: <wrfjk27aid6n.fsf@gmail.com>
        <20170330073808.6176-1-zlliu@suse.com>
        <87d1cukszu.fsf@notabene.neil.brown.name>
        <5B908F2B-D84A-4C4E-A0C6-863B6E793D75@suse.com>
        <99E3B202-848D-49F2-BC8A-966A631DE508@suse.com>
        <877f30k7ks.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f30k7ks.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Tue, 04 Apr 2017 16:30:59 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Zhilong <zlliu@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Tue, Apr 04 2017, Zhilong wrote:
>
>> Send from iPhone
>>
>>> =E5=9C=A8 2017=E5=B9=B44=E6=9C=884=E6=97=A5=EF=BC=8C13:07=EF=BC=8CZhilo=
ng <zlliu@suse.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>=20
>>>=20
>>> Send from iPhone
>>>=20
>>>>> =E5=9C=A8 2017=E5=B9=B44=E6=9C=883=E6=97=A5=EF=BC=8C12:36=EF=BC=8CNei=
lBrown <neilb@suse.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> On Thu, Mar 30 2017, Zhilong Liu wrote:
>>>>>=20
>>>>> systemctl doesn't interpret mdadm-grow-continue@.service
>>>>> correctly due to the wrong argument provided in [service],
>>>>> it should be corrected %I as %i. Otherwise, if the service
>>>>> cannot start by systemctl and the reshap progress would be
>>>>> stuck all time when grows array from raid1 to raid5.
>>>>>=20
>>>>> reproduce steps:
>>>>> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
>>>>> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>>>>>=20
>>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>>>> ---
>>>>> systemd/mdadm-grow-continue@.service | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/systemd/mdadm-grow-continue@.service
>>>>> b/systemd/mdadm-grow-continue@.service
>>>>> index 5c667d2..882bc0b 100644
>>>>> --- a/systemd/mdadm-grow-continue@.service
>>>>> +++ b/systemd/mdadm-grow-continue@.service
>>>>> @@ -10,7 +10,7 @@ Description=3DManage MD Reshape on /dev/%I
>>>>> DefaultDependencies=3Dno
>>>>>=20
>>>>> [Service]
>>>>> -ExecStart=3DBINDIR/mdadm --grow --continue /dev/%I
>>>>> +ExecStart=3DBINDIR/mdadm --grow --continue /dev/%i
>>>>=20
>>>> Do you know why this makes a difference?  I don't think it should.
>>>> man systemd.unit says that "%i" is the "Instance name" while "%I" is t=
he
>>>> "Unescaped instance name".
>>>>=20
>>>> The Instance name here is something like "md0" so there is nothing to
>>>> escape.
>>>>=20
>>>> I would rather not change it unless we know exactly why it is broken,
>>>> and I don't find your explanation to be convincing.
>>>>=20
>>>=20
>>> Exactly, you're correct, in this case, %i and %I are the same. The
>>> root cause is the ExecStart part, all the path name should be
>>> verified by systemd-escape=EF=BC=8Csuch as:
>>> /sbin/mdadm should be corrected as sbin-mdadm, and /dev/%I should
>>> be -dev-%I. Thus I'm sorry for this patch, I do agree with you not
>>> to change it. And say sorry to Jes.
>>>=20
>>
>> How about modifying this patch as:
>>
>> ExecStart=3D-sbin-mdadm --grow --continue -dev-%I
>>
>
> Why do you think anything needs changing here?
>
> I have a tumbleweed install with the standard
> mdadm-grow-continue@.server
> file. i.e.
>
>   ExecStart=3D/sbin/mdadm --grow --continue /dev/%I=20
>
> I run
>   strace -f -s 1000 -p 1 -o /tmp/strace
>
> in one window, then
>
>   systemctl start mdadm-grow-continue@md0.service
>
> in another.
>
> Then
>
>  grep execve /tmp/strace
>
> shows:
>
> 18680 execve("/sbin/mdadm", ["/sbin/mdadm", "--grow", "--continue", "/dev=
/md0"], [/* 3 vars */] <unfinished ...>
>
> which shows that mdadm is being correctly.
>
> There is nothing to fix here that I can see.

Unless I see some convincing arguments, I am going to revert this
patch.

Jes
