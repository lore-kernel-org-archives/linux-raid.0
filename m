From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Wed, 11 Nov 2009 16:48:42 -0800
Message-ID: <babafd2f0911111648p39c1c09ep92344eb6d5595524@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	<4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
	<babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
	<4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
	<babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
	<4AF5A920.1020601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF5A920.1020601@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 7, 2009 at 9:06 AM, Doug Ledford <dledford@redhat.com> wrot=
e:
>> Ok. =A0That still doesn't address why different commands in mdadm
>> generate different numbering schemes.
>
> The answer to that is technical implementation details.
<snip>

Ok, that's clear now.

>> How do I change the name=3D spec'n? ...

=2E..
> So, if the name=3D
> option is in your mdadm.conf ARRAY line for the array, then changing =
the
> name of the array will require that you do everything I listed above =
to
> update the mdadm.conf file in your mkinitrds and such or else the sys=
tem
> won't boot after you update the name in the superblock. =A0One last t=
hing,
> if this is a / array, then since the only way to update the name is
> during assembly, you would have to boot the system from rescue CD and
> assemble the array by hand, or else modify the init script in an init=
rd
> image to do the update for you. =A0Neither of which is a necessarily =
easy
> task if you don't know what you are doing.

Whew.  Messy, but once again clear.

Thanks for the help.

BenDJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
