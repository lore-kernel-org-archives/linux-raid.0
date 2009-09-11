From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid 5 Read performance
Date: Fri, 11 Sep 2009 21:22:31 +0300
Message-ID: <70ed7c3e0909111122n6b78a45asc92cd0b84d70f07a@mail.gmail.com>
References: <70ed7c3e0909101317l3298743co414a2626c765d00c@mail.gmail.com>
	<918883.43112.qm@web94815.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <918883.43112.qm@web94815.mail.in2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: satha kottidi <satha_koti@yahoo.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All kernel changes are mentioned in the changelogs, so I think you can
find what you want at kernel.org -- it also mentions who did the
change, so you can contact him/her directly.

I'm not saying you won't find help here, but the aforementioned is a
better chance :)

On Fri, Sep 11, 2009 at 6:48 PM, satha kottidi<satha_koti@yahoo.co.in> =
wrote:
> Hi Majed & All,
>
> Yes we two are working together. Actually we found a change in md/rai=
d5.c
> file in the function sync_request() it restricts the numbers, the ker=
nel
> 2.6.27 has code like this
>
> while(unlikely(!handle_stripe(sh, NULL)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ;
> =C2=A0But in kernel 2.6.21 it simply the handle_stripe(sh, NULL) call=
=2E
>
> Can anybody tell me the necessity of the change, and why it reduces t=
he
> numbers. Any comments is very helpful for me to analyze the driver fu=
rther.
>
>
> Thanks,
> Satha.
>
> --- On Fri, 11/9/09, Majed B. <majedb@gmail.com> wrote:
>
> From: Majed B. <majedb@gmail.com>
> Subject: Re: Raid 5 Read performance
> To: "Koti" <satha_koti@yahoo.co.in>
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 11 September, 2009, 1:47 AM
>
> Someone else has already emailed the mailing list about this. Are you
> two running an assignment or something?!
>
> Check the mailing list archive for whatever people have already repli=
ed
> with.
>
> On Thu, Sep 10, 2009 at 11:07 PM, Koti<satha_koti@yahoo.co.in> wrote:
>> Hi All
>>
>> I am trying measure the RAID 5 Read numbers on linux kernel-2.6.21 a=
nd
>> kernel 2.6.27 the numbers are lower on later kernel (2.6.27). Iam
>> measuring
>> the numbers using "time dd" command (4GB ). Is any valid reason for =
this,
>> or
>> Am missing anything in the process. Can anybody help me in analyze t=
his
>> problem.
>>
>> Thanks,
>> Koti
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0Majed B.
>
> ________________________________
> Connect more, do more and share more with Yahoo! India Mail. Learn mo=
re.



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
