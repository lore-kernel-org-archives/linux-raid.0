From: "Majed B." <majedb@gmail.com>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Wed, 9 Sep 2009 12:00:38 +0300
Message-ID: <70ed7c3e0909090200p5fb4eed3r6a3ed6988541a903@mail.gmail.com>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
	<slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org> <20090908184837.GA28217@teal.hq.k1024.org>
	<4AA70604.7020709@harddata.com> <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If there's no specific utility from the manufacturer for Linux, you
might want to take a look at "sdparm"

On Wed, Sep 9, 2009 at 11:21 AM, Simon Jackson<sjackson@bluearc.com> wr=
ote:
> This sounds an interesting proposition for RAID 1 setups that I am us=
ing. =C2=A0In a couple of cases I have seen unresponsive drives retryin=
g on a bad block seemingly to lock up my system, or at least slow respo=
nse significantly.
>
> In my case I am using Seagate and Hitachi drives. =C2=A0A look at Wik=
ipedia indicates that on Hitachi there is something called "Command Com=
pletion Time Limit" and on Seagate "Error Recovery Control".
>
> Please can anyone tell me how I would go about setting timeout values=
 on these types of drive. Are there utility programs to do this or a Li=
nux
> command.
>
> Thanks Simon.
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Maurice Hilarius
> Sent: 09 September 2009 02:34
> To: Mario 'BitKoenig' Holbe
> Cc: linux-raid@vger.kernel.org; iusty@k1024.org
> Subject: Re: mdadm and TLER (Time Limited Error Recovery)
>
> Iustin Pop wrote:
>> ..
>>> Anyways, clarification...
>>> The only reason for TLER (Time Limited Error Recovery) is to behave
>>> "friendly" toward RAID controllers that timeout disks.
>>> In fact, md does not timeout disks as many Hardware RAID controller=
s do.
>>> So, from md's point of view, TLER is useless, i.e. it has no benefi=
t.
>>>
>>
>> I'm sorry but I disagree here. *Especially* because md is used over
>> normal SATA controllers most of the time, TLER is beneficial because=
 the
>> drive doesn't go catatonic for minutes at a time trying to recover a=
 bad
>> sector, which would (because md doesn't timeout disks) cause md to h=
ung
>> up the whole device. TLER will allow md to see the error quickly and
>> attempt to rewrite (read) or retry/fail the disk (write) for a bad t=
he
>> sector.
>>
>> Just my understanding of the md stack.
>>
>> regards,
>> iustin
>>
>>
> I agree.
> Before WD implemented this we would see cases quite often where a
> perfectly good drive would get "kicked out"
> of a RAID as frequently or even more often, than on a hardware RAID.
> TLER management seems to have eliminated most of these cases.
>
>
>
> --
> Regards, Maurice
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
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
