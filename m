From: "Majed B." <majedb@gmail.com>
Subject: Re: LVM and Raid5
Date: Wed, 16 Sep 2009 13:20:40 +0300
Message-ID: <70ed7c3e0909160320j68c792d2g8ba01ac3c34eaae5@mail.gmail.com>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
	<87ocpb5hft.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ocpb5hft.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm the one who ran those tests with LVM vs. RAID5 and I think I have
faced speed difference because I have disks of varying speeds
(different models and vendors), and I believe that LVM gets crippled
down to the speed of the slowest disk.

On Wed, Sep 16, 2009 at 1:09 PM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Linux Raid Study <linuxraid.study@gmail.com> writes:
>
>> Hello:
>>
>> Has someone experimented with LVM and Raid5 together (on say, 2.6.27=
)?
>> Is there any performance drop if LVM/Raid5 are combined vs Raid5 alo=
ne?
>>
>> Thanks for your inputs!
>
> Has always worked perfectly for me and i can't say I noticed any
> performance change.
>
> MfG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Goswin
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
