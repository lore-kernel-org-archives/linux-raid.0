From: "Majed B." <majedb@gmail.com>
Subject: Re: Help - Urgent!!!
Date: Sat, 14 Nov 2009 03:34:05 +0300
Message-ID: <70ed7c3e0911131634l506e8c19o9f30886ae097c6ba@mail.gmail.com>
References: <200911122253.01626.lrhorer@satx.rr.com> <200911130913.48292.lrhorer@satx.rr.com>
	<19197.55846.756558.21650@notabene.brown> <200911131830.59009.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911131830.59009.lrhorer@satx.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey there,

Seems like this is an old bug. Check this:
http://www.issociate.de/board/post/328238/Unable_to_add_write-intent_bi=
tmap.html

I faced some weird problems before and when posting here, Neil Brown
suggested that I try mdadm 3.0 -- I compiled and everything went
smooth from there.

On Sat, Nov 14, 2009 at 3:30 AM, lrhorer@satx.rr.com
<lrhorer@satx.rr.com> wrote:
> On Friday 13 November 2009 04:13:58 pm you wrote:
>> On Friday November 13, lrhorer@satx.rr.com wrote:
>> > > There is nothing to delete. =C2=A0Just try to add it again.
>> > > Though I would really like to know why it hangs. =C2=A0If that h=
appens
>> > > again, see if alt-sysrq-T shows anything useful.
>> >
>> > =C2=A0 =C2=A0 sysrq?
>>
>> It is a key on the keyboard - up near "Prnt Scrn"
>>
>> Hold the 'alt' key, hold the 'sysrq' key, then type 't'.
>> It spews lot of stack traces on to the screen. =C2=A0It is really on=
ly
>> useful with a series console, of if the machine is working well enou=
gh
>> for all the text to go in to log files.
>>
>> alt-sysrq-P is less verbose and can also be useful.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm on an X login. =C2=A0It produces nothi=
ng. =C2=A0Does it only work with a hung
> command line?
>
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
