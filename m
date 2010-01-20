From: "Majed B." <majedb@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Thu, 21 Jan 2010 01:30:15 +0300
Message-ID: <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org>
	<70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com>
	<hj7vta$nvq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj7vta$nvq$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

He needs to run a full offline or long test before checking with
smartctl -a -- since it won't show any sector errors if those tests
weren't run at least once.

On Thu, Jan 21, 2010 at 1:25 AM, Brett Russ <bruss@netezza.com> wrote:
> On 01/20/2010 03:44 PM, Majed B. wrote:
>>
>> You can find details on these parameters and their values in md's
>> documentation: http://www.mjmwired.net/kernel/Documentation/md.txt
>>
>> A mismatch count can be checked by writing "check" to the proper fil=
e
>> as stated in line 376:
>> http://www.mjmwired.net/kernel/Documentation/md.txt#376
>
> Sounds like Jon may have a flaky HDD if certain members continually t=
hrow
> errors. =C2=A0Jon, can you check SMART stats on your drives?
>
> for di in a b c d e f g; do smartctl -a /dev/sd$di | grep -i _sect; d=
one
>
> you may have to add another option to smartctl, I forget.
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
