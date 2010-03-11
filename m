From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: ANNOUNCE: mdadm 3.1.2 - A tool for managing Soft RAID under Linux
Date: Thu, 11 Mar 2010 03:58:24 -0800
Message-ID: <4877c76c1003110358x2255d4bt1115ca184242ba5e@mail.gmail.com>
References: <19351.10758.612499.310262@notabene.brown>
	 <4B98D322.7010101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B98D322.7010101@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 3:25 AM, Asdo <asdo@shiftmail.org> wrote:
> Neil Brown wrote:
>>
>> I am pleased to announce the availability of
>> =A0 mdadm version 3.1.2
>>
>> [CUT]
>>
>> Significant changes are:
>> =A0- The default metadata has change again (sorry about that).
>> =A0 =A0It is now v1.2 and will hopefully stay that way. [CUT]
>>
>
> I remember some discussion about alignment for 1.1 and 1.2: is it pos=
sible
> on 1.2 to guarantee alignment of RAID device on the physical devices?
> 4K alignment would be needed on SSDs and 2TB disks w/ 4k physical 512=
b
> logical emulation. Actually on SSDs the alignment could be even more =
than
> 4k, I am not sure.
> Should we bypass the defaults and put 1.0 metadata on those?
> What was the downside of 1.0 so that it was not made default?
>
> Thanks for your great job
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

1.0 puts the metadata at the end.  You run in to situations where
various tools that detect what's inside of a block device get confused
about if it's an md member, or whatever's been stuffed inside of md
(and is thus stored at the front) instead.

What would be nice would be the ability to specify a non-default
alignment unit and a reference sector in the backing device to use for
the start of alignment.  However I don't think anyone who's really
needed it has yet seen fit to provide a patch.

Presuming someone did want to write a patch, is the above outlined
pair of options desirable as the solution, and what sort of long/short
names might be used?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
