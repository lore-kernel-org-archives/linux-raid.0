From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Raid failure - drives or controller?
Date: Wed, 7 Mar 2012 21:11:02 +0000
Message-ID: <CADNH=7Hme2BOCjBC9gw4YiTXkTGg6tw5EmH6bhuEx0_+05Wupg@mail.gmail.com>
References: <4F57A05E.6000204@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F57A05E.6000204@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 March 2012 17:52, Danilo Godec <danilo.godec@agenda.si> wrote:
> Hi,
>
> I had two drive failure on a RAID5 in short time (unfortunately to sh=
ort to
> rebuild on a spare disk). However - drives seem to work on a test mac=
hine
> and didn't report any errors. I also stuck them back into the orig. s=
erver
> (after rebooting) and they work now.
>
> The first drive's errors were:
>
>> Mar =C2=A06 05:15:19 san1 kernel: [10681162.473960] sd 4:0:3:0: [sde=
] Result:
>> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>> Mar =C2=A06 05:15:19 san1 kernel: [10681162.473965] sd 4:0:3:0: [sde=
] Sense Key
>> : Aborted Command [current]
>> Mar =C2=A06 05:15:19 san1 kernel: [10681162.473969] sd 4:0:3:0: [sde=
] Add.
>> Sense: No additional sense information
>> Mar =C2=A06 05:15:19 san1 kernel: [10681162.473973] sd 4:0:3:0: [sde=
] CDB:
>> Read(10): 28 00 07 af 38 3f 00 00 08 00
>> Mar =C2=A06 05:15:19 san1 kernel: [10681162.473980] end_request: I/O=
 error, dev
>> sde, sector 128923711
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885221] sd 4:0:3:0: [sde=
] Result:
>> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885225] sd 4:0:3:0: [sde=
] Sense Key
>> : Illegal Request [current]
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885229] sd 4:0:3:0: [sde=
] Add.
>> Sense: Logical block address out of range
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885234] sd 4:0:3:0: [sde=
] CDB:
>> Write(10): 2a 08 74 70 58 c7 00 00 08 00
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885242] end_request: I/O=
 error, dev
>> sde, sector 1953519815
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885246] end_request: I/O=
 error, dev
>> sde, sector 1953519815
>> Mar =C2=A06 05:17:53 san1 kernel: [10681316.885252] raid5: Disk fail=
ure on
>> sde1, disabling device.
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600610] sd 4:0:3:0: [sde=
] Result:
>> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600615] sd 4:0:3:0: [sde=
] Sense Key
>> : Illegal Request [current]
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600619] sd 4:0:3:0: [sde=
] Add.
>> Sense: Logical block address out of range
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600624] sd 4:0:3:0: [sde=
] CDB:
>> Write(10): 2a 08 74 70 59 27 00 00 08 00
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600631] end_request: I/O=
 error, dev
>> sde, sector 1953519911
>> Mar =C2=A06 05:20:27 san1 kernel: [10681470.600636] end_request: I/O=
 error, dev
>> sde, sector 1953519911
>> Mar =C2=A06 05:20:28 san1 kernel: [10681471.664682] =C2=A0disk 3, o:=
0, dev:sde1
>> Mar =C2=A06 05:21:47 san1 kernel: [10681549.746852] sd 4:0:3:0: [sde=
]
>> Synchronizing SCSI cache
>> Mar =C2=A06 05:21:47 san1 kernel: [10681549.746905] sd 4:0:3:0: [sde=
] Result:
>> hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
>
>
> The second drive did this:
>
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.197391] sd 4:0:5:0: [sdg=
] Result:
>> hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.197396] sd 4:0:5:0: [sdg=
] Sense Key
>> : Aborted Command [current]
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.197400] sd 4:0:5:0: [sdg=
] Add.
>> Sense: No additional sense information
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.197404] sd 4:0:5:0: [sdg=
] CDB:
>> Read(10): 28 00 07 12 05 9f 00 00 10 00
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.197411] end_request: I/O=
 error, dev
>> sdg, sector 118621599
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.583990] raid5: Disk fail=
ure on
>> sdg1, disabling device.
>> Mar =C2=A07 02:31:37 san1 kernel: [10757598.616232] =C2=A0disk 5, o:=
0, dev:sdg1
>
>
> Can anyone make some actual sense out of these sense messages?
>
> Are these drives really / likely bad or is it more likely it was a
> controller failure?
>
>
> =C2=A0 D.
>
>
> --
> Danilo Godec, sistemska podpora / system administration
>
> Predlog! Obiscite prenovljeno spletno stran www.agenda.si
>
> ODPRTA KODA IN LINUX
> STORITVE : POSLOVNE RESITVE : UPRAVLJANJE IT : INFRASTRUKTURA IT :
> IZOBRAZEVANJE : PROGRAMSKA OPREMA
>
> Visit our updated web page at www.agenda.si
>
> OPEN SOURCE AND LINUX
> SERVICES : BUSINESS SOLUTIONS : IT MANAGEMENT : IT INFRASTRUCTURE : T=
RAINING
> : SOFTWARE
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Can you please post the smartctl -a (from smartmontools) output for bot=
h drives?

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
