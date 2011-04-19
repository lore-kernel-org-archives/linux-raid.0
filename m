From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 16:41:28 +0100
Message-ID: <BANLkTi=HPO4-n+1JEtNoTzuxCiOteJnoyw@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org>
	<BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>
	<iok4of$eov$1@dough.gmane.org>
	<BANLkTince3_8ziNUB+DYkL2Dfkmb21DAVg@mail.gmail.com>
	<iok8o1$97l$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iok8o1$97l$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 April 2011 16:12, David Brown <david@westcontrol.com> wrote:
> On 19/04/2011 16:07, Mathias Bur=C3=A9n wrote:
>>
>> On 19 April 2011 15:04, David Brown<david@westcontrol.com> =C2=A0wro=
te:
>>>
>>> On 19/04/2011 15:25, Mathias Bur=C3=A9n wrote:
>>>>
>>>> On 19 April 2011 14:21, David Brown<david@westcontrol.com> =C2=A0 =
=C2=A0wrote:
>>>>>
>>>>> I have recently got an IBM x3650 M3 server, which has a "Serverai=
d
>>>>> M5014"
>>>>> raid controller. =C2=A0Booting from a Linux CD (system rescue CD)=
 and
>>>>> running
>>>>> lspci identifies this raid controller as:
>>>>>
>>>>> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>>>>>
>>>>> The controller works fine for hardware raid - I can open its bios=
 setup
>>>>> utility, and set up a RAID5 (or whatever) with the disks I have. =
=C2=A0The
>>>>> OS
>>>>> then just sees a single virtual disk.
>>>>>
>>>>> But I would like direct access to the sata drives - I want to set=
 up
>>>>> mdadm
>>>>> raid, under my own control. =C2=A0As far as I can see, there is n=
o way to
>>>>> put
>>>>> this controller into "JBOD" or "direct access" mode of any sort.
>>>>>
>>>>> Does anyone here have experience with this card, or can give me a=
ny
>>>>> hints?
>>>>>
>>>>> The only idea I have at the moment is to put each disk within its=
 own
>>>>> single-disk RAID 0 set, but then I don't get sata hot-swap
>>>>> functionality,
>>>>> SMART, hddtemp, etc.
>>>>>
>>>>> Thanks for any clues or hints,
>>>>>
>>>>> David
>>>>>
>>>>
>>>> Regarding SMART, could you try (after loading the appropriate
>>>> megaraid/megasas module) hdparm -a -d megaraid,$I /dev/sda , where=
 $I
>>>> is a number between 0 and 31 IIRC (depending on the HDD in the arr=
ay).
>>>>
>>>
>>> Are you sure about the syntax for that command? =C2=A0Trying that w=
ith "0" for
>>> $I
>>> just gives me "megaraid,0: No such file or directory". =C2=A0As far=
 as I can
>>> see,
>>> the megaraid module is loaded (lsmod shows "megaraid_sas" in the mo=
dules
>>> list).
>>>
>>> Thanks anyway,
>>>
>>> David
>>>
>>>
>>
>> =C2=A0From the smartctl man page:
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Under Linux , to look at SCSI/SAS =
disks behind LSI MegaRAID
>> controllers, use syntax such as:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smartctl -a -d mega=
raid,2 /dev/sda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smartctl -a -d mega=
raid,0 /dev/sdb
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 where =C2=A0in the =
argument megaraid,N, the integer N is the
>> physical disk number within the MegaRAID controller. =C2=A0This inte=
rface
>> will also work for Dell PERC controllers. =C2=A0The follow=E2=80=90
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ing /dev/XXX entry =
must exist:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 For PERC2/3/4 contr=
ollers: /dev/megadev0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 For PERC5/6 control=
lers: /dev/megaraid_sas_ioctl_node
>>
>> Maybe you can experiment some with that. Regards,
>> M
>
> Ah, it was "smartctl" - you first wrote "hdparm". =C2=A0I should have=
 thought of
> smartctl myself.
>
> Still no luck as yet - the smartctl on my test installation (Centos 5=
=2E6)
> doesn't seem to support megaraid devices. =C2=A0But maybe that's just=
 because it
> is an older version of smartctl - Centos 5.6 is not exactly "bleeding=
 edge".
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Opps, sorry! I blame the medicine. You could try compile a version of
smartctl yourself if you have the proper packages installed.

Regards,
M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
