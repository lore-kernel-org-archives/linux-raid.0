From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Striping does not increase performance.
Date: Mon, 12 Mar 2012 14:02:36 +0100
Message-ID: <CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
	<20120312125720.GL4558@voyageur.mas.nom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120312125720.GL4558@voyageur.mas.nom.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Erwan MAS <erwan@mas.nom.fr>
Cc: linux-raid@vger.kernel.org, fio@vger.kernel.org
List-Id: linux-raid.ids

Hi Erwan,

I do not use partitions on the drives so the whole disk /dev/sdb is
used as md component device, i was in the understanding that if not
using partitions the alignment is correct or am i wrong?

Kind regards,

Caspar Smit

Op 12 maart 2012 13:57 heeft Erwan MAS <erwan@mas.nom.fr> het volgende
geschreven:
> On Mon, Mar 12, 2012 at 01:34:08PM +0100, Caspar Smit wrote:
>> Hi all,
>>
>> I don't know exactly which mailinglists to use for this one so I hop=
e
>> i used the right ones.
>>
>> I did some performance testing on a new system and found out some
>> things I couldn't explain or didn't expect.
>> At the end are some questions I hope to get answered to explain the
>> tings i'm seeing in the test.
>>
>> First of all a description of my setup.
>>
>> The server is a 36 bay 3,5" supermicro chassis filled with 36x 2TB
>> SATA 7200 RPM disks.
>> [../..]
>
> Please check alignement of each level of stockage .
> Because this disk present to controller a block size of 512 bytes , b=
ut internal
> use a 4k block size .
>
> You must check that alignement is correct for :
> =A0disk partionnemnt
> =A0md device
> =A0pv lvm
>
> --
> =A0 =A0 ____________________________________________________________
> =A0 =A0/ Erwan MAS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /\
> =A0 | mailto:erwan@mas.nom.fr =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |_/
> ___|________________________________________________________ =A0 |
> \___________________________________________________________\__/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
