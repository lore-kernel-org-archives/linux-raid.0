From: jin zhencheng <zhenchengjin@gmail.com>
Subject: Re: BUG:write data to degrade raid5
Date: Mon, 22 Mar 2010 09:41:38 +0800
Message-ID: <de04351e1003211841i3c3070b1ob033ee09a21dc8f1@mail.gmail.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
	 <4BA3C07A.8030204@gmx.net>
	 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
	 <4BA3C461.5060209@gmx.net>
	 <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
	 <20100321130426.GB15746@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100321130426.GB15746@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Joachim Otahal <Jou@gmx.net>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

don't have swap on the RAID.

On Sun, Mar 21, 2010 at 9:04 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 21 Mar 2010, jin zhencheng wrote:
>> ths for your test on "Debian 2.6.26-21lenny4".
>> if you want to see the oop ,you should always write to the raid5 ,an=
d
>> pull 2 disks out.maybe you can see the error
>>
>> i think no matter what i do ,even if i pull out all the disk , kerne=
l
>> should not oop.
>
> You don't have swap (file or partition, doesn't matter) on that RAID,=
 do
> you?
>
> --
> =A0"One disk to rule them all, One disk to find them. One disk to bri=
ng
> =A0them all and in the darkness grind them. In the Land of Redmond
> =A0where the shadows lie." -- The Silicon Valley Tarot
> =A0Henrique Holschuh
>
