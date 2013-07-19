From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 09:02:20 +0200
Message-ID: <CAC9WiBgJnw0vVn66ZYeUGQ06PzSEdULOt3hr9sx7XM9m9rhs5Q@mail.gmail.com>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
	<51E85949.2020107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51E85949.2020107@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff.npl@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Thu, Jul 18, 2013 at 11:08 PM, Stefan /*St0fF*/ H=FCbner
<st0ff.npl@googlemail.com> wrote:
> Am 18.07.2013 22:37, schrieb Francis Moreau:
>> Hello,
>>
>> Sorry if the question is stupid but I'm a rookie in md things, but I=
'd
>> like to understand the big picture here.
>
> Probably a bit of good googling would have given your answers right a=
way.
>

Not really. You think such because you might have missed the point of
my question which is about how does coexists with bios raid.

>>
>> I've been told to use mdadm whenever possible even if my raid is
>> handled by the bios (fake raid) which use the ddf metadata format.
>> (unfortunately it seems that I can't desactive this fake raid in
>> favour of linux soft raid). It's RAID1 BTW.
>
> There are two types of fakeraid that I know of.  Intel and MegaRAID/L=
SI
> emulation.  Those are NOT handled by the BIOS, the boot process is
> handled by the special op-rom integrated into the BIOS.

Well what's the difference ? Of course a bios is not a piece of
hardware with a dedicated cpu. So when I said it's handled by the
bios, I obviously meant that there's a software stored in the firmware
which is executed by my the processor and this soft can be configured
through the bios.

>  After any
> kernel is booted, all RAID processing shall be done by the respective
> driver.  And none use DDF afaik.  Intel uses its own metadata format
> (referred to as IMSM), LSI also uses its own format (those fakeraid
> drives can be attached to f.e. a MegaRAID 9266 controller and your RA=
ID
> is then recognized - those 9266 f.e. can create DDF arrays).

You probably have missed a lot more.

Bye,
--
=46rancis
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
