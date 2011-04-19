From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 15:07:22 +0100
Message-ID: <BANLkTince3_8ziNUB+DYkL2Dfkmb21DAVg@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org>
	<BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>
	<iok4of$eov$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iok4of$eov$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 April 2011 15:04, David Brown <david@westcontrol.com> wrote:
> On 19/04/2011 15:25, Mathias Bur=C3=A9n wrote:
>>
>> On 19 April 2011 14:21, David Brown<david@westcontrol.com> =C2=A0wro=
te:
>>>
>>> I have recently got an IBM x3650 M3 server, which has a "Serveraid =
M5014"
>>> raid controller. =C2=A0Booting from a Linux CD (system rescue CD) a=
nd running
>>> lspci identifies this raid controller as:
>>>
>>> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>>>
>>> The controller works fine for hardware raid - I can open its bios s=
etup
>>> utility, and set up a RAID5 (or whatever) with the disks I have. =C2=
=A0The OS
>>> then just sees a single virtual disk.
>>>
>>> But I would like direct access to the sata drives - I want to set u=
p
>>> mdadm
>>> raid, under my own control. =C2=A0As far as I can see, there is no =
way to put
>>> this controller into "JBOD" or "direct access" mode of any sort.
>>>
>>> Does anyone here have experience with this card, or can give me any
>>> hints?
>>>
>>> The only idea I have at the moment is to put each disk within its o=
wn
>>> single-disk RAID 0 set, but then I don't get sata hot-swap function=
ality,
>>> SMART, hddtemp, etc.
>>>
>>> Thanks for any clues or hints,
>>>
>>> David
>>>
>>
>> Regarding SMART, could you try (after loading the appropriate
>> megaraid/megasas module) hdparm -a -d megaraid,$I /dev/sda , where $=
I
>> is a number between 0 and 31 IIRC (depending on the HDD in the array=
).
>>
>
> Are you sure about the syntax for that command? =C2=A0Trying that wit=
h "0" for $I
> just gives me "megaraid,0: No such file or directory". =C2=A0As far a=
s I can see,
> the megaraid module is loaded (lsmod shows "megaraid_sas" in the modu=
les
> list).
>
> Thanks anyway,
>
> David
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

=46rom the smartctl man page:

         Under Linux , to look at SCSI/SAS disks behind LSI MegaRAID
controllers, use syntax such as:
              smartctl -a -d megaraid,2 /dev/sda
              smartctl -a -d megaraid,0 /dev/sdb
              where  in the argument megaraid,N, the integer N is the
physical disk number within the MegaRAID controller.  This interface
will also work for Dell PERC controllers.  The follow=E2=80=90
              ing /dev/XXX entry must exist:
              For PERC2/3/4 controllers: /dev/megadev0
              For PERC5/6 controllers: /dev/megaraid_sas_ioctl_node

Maybe you can experiment some with that. Regards,
M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
