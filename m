From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 15:34:17 -0400
Message-ID: <AANLkTi=iUUT_qZdg7gtxfroT+Y-c92SKQbhtUGhWwE=e@mail.gmail.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
	<AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
	<alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
	<AANLkTikOr3LdZ_uy5Vnj=wu0k7Ag8A+LXRYwxf69YNOv@mail.gmail.com>
	<20100926103818.GA5719@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100926103818.GA5719@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> > You need to start looking in dmesg / other logs to see what has ha=
ppened and
>> > why things have failed. Without that information it's impossible t=
o tell
>> > what's going on.
>> >
>> I've uploaded the dmesg output starting with the reshape to
>> www.hartmanipulation.com/raid/dmesg_6.txt. It looks like /dev/sdd is
>> having some kind of intermittent read issues (which wasn't happening
>> before the reshape started) but I still don't understand why it
>> wouldn't be marked as failed in the md2 section of mdstat, since md0
>> is accessing it via md2.
>>
> I think this is because it's a RAID0 array. =A0It can't fail the devi=
ce
> without (irrecoverably) failing the array, so it's left to the normal
> block device error reporting/handling process.

I guess that makes sense.

>
>> At any rate, that doesn't help me with my most immediate issue: does=
 a
>> drive failing during a reshape corrupt the array? Or am I safe to
>> resume the reshape? Is there any way to restore my safety net a bit
>> before resuming the reshape, or will I just have to hope nothing els=
e
>> goes wrong between now and the time the new hot spare is finally
>> incorporated?
>>
> Failure of a device during the reshape certainly shouldn't corrupt th=
e
> array (I don't see how it would anyway, unless there's a screw-up in =
the
> code).

I guess I was thinking that the reshape was restriping all the data
under the assumption of 7 (or 8) drives, and one failing might change
the restriping requirements in midstream and leave it in an
unrecoverable in-between state. Very glad to hear that's not the case.

> I don't think there's any way to "restore your safety net"
> though (short of imaging all the drives as backups), but it's probabl=
y
> worth while doing a read test of all member devices before you contin=
ue.

Can you recommend a good way to perform such a read test? Would I just
dd the entire contents of each disk to /dev/null or is there a more
efficient way of doing it?

>
> Cheers,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |

Thanks for the help Robin!

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
