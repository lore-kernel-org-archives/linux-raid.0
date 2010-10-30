From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: Re: argh!
Date: Sat, 30 Oct 2010 23:01:15 +0100
Message-ID: <AANLkTikWcSYEAiqh_Adwg-h71h5y6hmEbLFttg2vRoHG@mail.gmail.com>
References: <4CCC3DB6.3020500@turmel.org>
	<3E.D6.13137.8D98CCC4@cdptpa-omtalb.mail.rr.com>
	<AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>
	<AANLkTimeu=M-m4iKO=1Q_ALb47ST1uvtZavy2yk0NA-a@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimeu=M-m4iKO=1Q_ALb47ST1uvtZavy2yk0NA-a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry to spam.. if i run

'mdadm --assemble --scan -R'

the array assemles in an inactive state but it is suggesting i use
force.. but I am worried about doing damage?

Also, perhaps some extra commands for thick people would be cool? i.e.
force for things that are ideal.. like mounting an incomplete array
but having to specifiy it twice i.e. '-F -F' for things that can do
damage?

On 30 October 2010 22:54, Jon Hardcastle <jonathan.hardcastle@gmail.com=
> wrote:
> Also,
>
> What commands can I not run? I.e. what are destructive?
>
>
>
> On 30 October 2010 22:52, Jon Hardcastle <jonathan.hardcastle@gmail.c=
om> wrote:
>> On 30 October 2010 22:10, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>>>> -----Original Message-----
>>>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>>> owner@vger.kernel.org] On Behalf Of Phil Turmel
>>>> Sent: Saturday, October 30, 2010 10:46 AM
>>>> To: Jon@eHardcastle.com
>>>> Cc: Jon Hardcastle; linux-raid@vger.kernel.org
>>>> Subject: Re: argh!
>>>>
>>>> On 10/30/2010 07:56 AM, Jon Hardcastle wrote:
>>>> > Guys,
>>>> >
>>>> > a new HDD has failed on me during a scrub.... i tried to remove/=
fail it
>>>> but
>>>> > it kept saying the device was busy. so i forced a reboot.
>>>> >
>>>> > I have physically disconnected the drive..
>>>> >
>>>> > can anyone take alook at the examine below and tell me if it is =
should
>>>> > assemble ok?
>>>> >
>>>> > I tried
>>>> >
>>>> > mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sde=
1
>>>> /dev/sdf1
>>>> > /dev/sdg1
>>>>
>>>> I'd try:
>>>>
>>>> mdadm --assemble /dev/md4 /dev/sd{g,a,e}1 missing /dev/sd{d,b,f}1
>>>
>>>
>>> =A0 =A0 =A0 =A0Yeah, I would, too. =A0Also, what are the contents o=
f
>>> /etc/mdadm/mdadm.conf? =A0If it is correct, then `mdadm --assemble =
--scan`
>>> should work.
>>>
>>>
>>
>> Hey, yeah I am confused as drives have failed before and it has stil=
l
>> assembled. I think it is because it is unclean....
>>
>> Can I ask how did you arrive at the command list? what is wrong with=
 dbf?
>>
>> also this is my mdadm.conf
>>
>>
>> DEVICE /dev/sd[abcdefg]1 /dev/hd[ab]1
>>
>> ARRAY /dev/md/4 metadata=3D0.90 UUID=3D7438efd1:9e6ca2b5:d6b88274:70=
03b1d3
>> ARRAY /dev/md/3 metadata=3D0.90 UUID=3Da1f24bc9:4e72a820:3a03f7dc:07=
f9ab98
>> ARRAY /dev/md/2 metadata=3D0.90 UUID=3D0642323a:938992ef:b750ab21:e5=
a55662
>> ARRAY /dev/md/1 metadata=3D0.90 UUID=3Dd4eeec62:148b3425:3f5e931c:bb=
3ef499
>>
>
>
>
> --
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> JK: "What's a wombat for? Why for hitting Woms of course!"
> 'Q': 'There comes a time when you look into the mirror, and you
> realise that what you see is all that you will ever be. Then you
> accept it, or you kill yourself. Or you stop looking into mirrors...
> :)'
>
> Please note, I am phasing out jonathan DOT hardcastle AT gmail.com an=
d
> replacing it with jon AT eHardcastle.com
> -----------------------
>



--=20
-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
JK: "What's a wombat for? Why for hitting Woms of course!"
'Q': 'There comes a time when you look into the mirror, and you
realise that what you see is all that you will ever be. Then you
accept it, or you kill yourself. Or you stop looking into mirrors...
:)'

Please note, I am phasing out jonathan DOT hardcastle AT gmail.com and
replacing it with jon AT eHardcastle.com
-----------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
