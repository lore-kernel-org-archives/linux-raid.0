From: "Majed B." <majedb@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 23:44:07 +0300
Message-ID: <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj77p7$rsr$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can find details on these parameters and their values in md's
documentation: http://www.mjmwired.net/kernel/Documentation/md.txt

A mismatch count can be checked by writing "check" to the proper file
as stated in line 376:
http://www.mjmwired.net/kernel/Documentation/md.txt#376

On Wed, Jan 20, 2010 at 6:34 PM, Brett Russ <bruss@netezza.com> wrote:
> On 01/20/2010 10:03 AM, Jon Hardcastle wrote:
>>
>> --- On Wed, 20/1/10, Brett Russ<bruss@netezza.com> =C2=A0wrote:
>>>
>>> What do you mean by mismatches detected? =C2=A0How is this observed=
?
>>
>> cat /sys/block/md4/md/mismatch_cnt
>
> Someone else will need to comment on what this value pertains to and =
how it
> should behave.
>
>> I have been able to get the info you asked for using mdadm -E but no=
t
>> with the array stopped. I cant stop it just yet. What would you be
>> looking for in this data?
>
> Simply that the "Update Time" and "Events" values matched across all
> members, which they do.
>
> -BR
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
