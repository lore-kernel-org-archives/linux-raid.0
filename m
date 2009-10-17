From: "Majed B." <majedb@gmail.com>
Subject: Re: Disappointing RAID10 Performance
Date: Sun, 18 Oct 2009 00:35:48 +0300
Message-ID: <70ed7c3e0910171435s53521b47ia7e88eaf62d65eb9@mail.gmail.com>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com> <4AD8BBC3.4030600@wpkg.org>
	<4AD9ECE4.3090202@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD9ECE4.3090202@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dd supports writing to multiple devices at once, but not reading from
multiple inputs.

On Sat, Oct 17, 2009 at 7:12 PM, Asdo <asdo@shiftmail.org> wrote:
> Tomasz Chmielewski wrote:
>>
>> If you start using your drives for two "dd if=3Dbigfile[12] of=3D/de=
v/null" at
>> the same time, you will notice the difference.
>
> OT: Does this dd line really work? I did see it elsewhere already but
> doesn't appear to work for me: seems to see only the last if=3D. I do=
n't think
> multiple input or output files are supported.
> For this kind of tests I was doing a for loop with background dd coma=
nds (
> trailing & ) IIRC
> This would be a good dd feature to simplify linux-raid performance te=
sting
> though.
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
