From: "Majed B." <majedb@gmail.com>
Subject: Re: LVM and Raid5
Date: Wed, 16 Sep 2009 14:00:30 +0300
Message-ID: <70ed7c3e0909160400k578741e7ue687d8fd983d0d12@mail.gmail.com>
References: <70ed7c3e0909160320j68c792d2g8ba01ac3c34eaae5@mail.gmail.com>
	<894436.58276.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <894436.58276.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tested with both dd and hdparm, and in both cases, md0 proved to be
much faster than the LV itself.

On Wed, Sep 16, 2009 at 1:33 PM, Jon Hardcastle <jd_hardcastle@yahoo.co=
m> wrote:
>
>
>
> --- On Wed, 16/9/09, Majed B. <majedb@gmail.com> wrote:
>
>> From: Majed B. <majedb@gmail.com>
>> Subject: Re: LVM and Raid5
>> To: "Goswin von Brederlow" <goswin-v-b@web.de>
>> Cc: "Linux Raid Study" <linuxraid.study@gmail.com>, linux-raid@vger.=
kernel.org
>> Date: Wednesday, 16 September, 2009, 11:20 AM
>> Hello,
>>
>> I'm the one who ran those tests with LVM vs. RAID5 and I
>> think I have
>> faced speed difference because I have disks of varying
>> speeds
>> (different models and vendors), and I believe that LVM gets
>> crippled
>> down to the speed of the slowest disk.
>>
>> On Wed, Sep 16, 2009 at 1:09 PM, Goswin von Brederlow
>> <goswin-v-b@web.de>
>> wrote:
>> > Linux Raid Study <linuxraid.study@gmail.com>
>> writes:
>> >
>> >> Hello:
>> >>
>> >> Has someone experimented with LVM and Raid5
>> together (on say, 2.6.27)?
>> >> Is there any performance drop if LVM/Raid5 are
>> combined vs Raid5 alone?
>> >>
>> >> Thanks for your inputs!
>> >
>> > Has always worked perfectly for me and i can't say I
>> noticed any
>> > performance change.
>> >
>> > MfG
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Goswin
>> > --
>> > To unsubscribe from this list: send the line
>> "unsubscribe linux-raid" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0Majed B.
>> --
>
> Is that the case even if a dd read from say md4 is much, much faster =
that he lvm's that are based on md4? Surely if the read from the underl=
ying md is faster so should the LV's?
>
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> 'Do not worry about tomorrow, for tomorrow will bring worries of its =
own.'
> -----------------------
>
>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
