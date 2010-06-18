From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: How to boost performance
Date: Fri, 18 Jun 2010 15:12:02 -0500
Message-ID: <AANLkTinV3i0vpR9i4_VCbcrGEqxoLGfQY_SrgDftQwJ_@mail.gmail.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
	<20100617100109.32a20ffa@natsu>
	<d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
	<20100617221300.3e30afe0@natsu>
	<db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
	<20100618020220.161c54b2@natsu>
	<20100617204327.GA21864@rap.rap.dk>
	<ccb4516c0633bda40a3160130d385c2b.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ccb4516c0633bda40a3160130d385c2b.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: Keld Simonsen <keld@keldix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 18, 2010 at 12:55 PM,  <aragonx@dcsnow.com> wrote:
>> On Fri, Jun 18, 2010 at 02:02:20AM +0600, Roman Mamedov wrote:
>> actually raid5 sequential reads can be faster than n-1 times the slo=
west
>> disk,
>> as it may skip the parity blocks faster than it could read them. Not=
 much,
>> probably.
>
> Hello all,
>
> So would I be correct in concluding that I am CPU bound at this point=
? =C2=A0My
> machine is busy creating the parity information so can not receive an=
y
> faster. =C2=A0A CPU replacement is in order but I have one question i=
n that
> direction. =C2=A0It appears that the md0 process is only using one co=
re. =C2=A0Is
> this because it is a single file being written? =C2=A0Should it be us=
ing both?
>
> The main thrust of this question is which type of CPU upgrade will he=
lp my
> situation. =C2=A0I could go for a faster MHz or more cores. =C2=A0Act=
ually, I can't
> go much faster on the MHz front. =C2=A0I think 3.4GHz is max and I'm =
at 3.0GHz.
>
> As always, thank you for all your advice.

Regardless of what top says, there is almost no way you could be cpu
bound, if you were cpu bound the IO rate should not get slower since
cpu does not go away, you would have to be backing up because the disk
subsystem cannot keep up.

You have some other issue, probably the fact that your sata ports are
running in IDE mode and not ACHI mode.

ACHI mode is newer and faster, IDE mode is older and less capable and s=
lower.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
