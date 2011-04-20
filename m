From: David Brown <david@westcontrol.com>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 10:08:51 +0200
Message-ID: <iom46s$pun$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org>	<BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>	<iok4of$eov$1@dough.gmane.org>	<BANLkTince3_8ziNUB+DYkL2Dfkmb21DAVg@mail.gmail.com>	<iok8o1$97l$1@dough.gmane.org> <BANLkTi=HPO4-n+1JEtNoTzuxCiOteJnoyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=HPO4-n+1JEtNoTzuxCiOteJnoyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/2011 17:41, Mathias Bur=C3=A9n wrote:
> On 19 April 2011 16:12, David Brown<david@westcontrol.com>  wrote:
>> On 19/04/2011 16:07, Mathias Bur=C3=A9n wrote:
>>>
>>> On 19 April 2011 15:04, David Brown<david@westcontrol.com>    wrote=
:
>>>>
>>>> On 19/04/2011 15:25, Mathias Bur=C3=A9n wrote:
>>>>>
>>>>> On 19 April 2011 14:21, David Brown<david@westcontrol.com>      w=
rote:
>>>>>>
>>>>>> I have recently got an IBM x3650 M3 server, which has a "Servera=
id
>>>>>> M5014"
>>>>>> raid controller.  Booting from a Linux CD (system rescue CD) and
>>>>>> running
>>>>>> lspci identifies this raid controller as:
>>>>>>
>>>>>> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>>>>>>
>>>>>> The controller works fine for hardware raid - I can open its bio=
s setup
>>>>>> utility, and set up a RAID5 (or whatever) with the disks I have.=
  The
>>>>>> OS
>>>>>> then just sees a single virtual disk.
>>>>>>
>>>>>> But I would like direct access to the sata drives - I want to se=
t up
>>>>>> mdadm
>>>>>> raid, under my own control.  As far as I can see, there is no wa=
y to
>>>>>> put
>>>>>> this controller into "JBOD" or "direct access" mode of any sort.
>>>>>>
>>>>>> Does anyone here have experience with this card, or can give me =
any
>>>>>> hints?
>>>>>>
>>>>>> The only idea I have at the moment is to put each disk within it=
s own
>>>>>> single-disk RAID 0 set, but then I don't get sata hot-swap
>>>>>> functionality,
>>>>>> SMART, hddtemp, etc.
>>>>>>
>>>>>> Thanks for any clues or hints,
>>>>>>
>>>>>> David
>>>>>>
>>>>>
>>>>> Regarding SMART, could you try (after loading the appropriate
>>>>> megaraid/megasas module) hdparm -a -d megaraid,$I /dev/sda , wher=
e $I
>>>>> is a number between 0 and 31 IIRC (depending on the HDD in the ar=
ray).
>>>>>
>>>>
>>>> Are you sure about the syntax for that command?  Trying that with =
"0" for
>>>> $I
>>>> just gives me "megaraid,0: No such file or directory".  As far as =
I can
>>>> see,
>>>> the megaraid module is loaded (lsmod shows "megaraid_sas" in the m=
odules
>>>> list).
>>>>
>>>> Thanks anyway,
>>>>
>>>> David
>>>>
>>>>
>>>
>>>   From the smartctl man page:
>>>
>>>           Under Linux , to look at SCSI/SAS disks behind LSI MegaRA=
ID
>>> controllers, use syntax such as:
>>>                smartctl -a -d megaraid,2 /dev/sda
>>>                smartctl -a -d megaraid,0 /dev/sdb
>>>                where  in the argument megaraid,N, the integer N is =
the
>>> physical disk number within the MegaRAID controller.  This interfac=
e
>>> will also work for Dell PERC controllers.  The follow=E2=80=90
>>>                ing /dev/XXX entry must exist:
>>>                For PERC2/3/4 controllers: /dev/megadev0
>>>                For PERC5/6 controllers: /dev/megaraid_sas_ioctl_nod=
e
>>>
>>> Maybe you can experiment some with that. Regards,
>>> M
>>
>> Ah, it was "smartctl" - you first wrote "hdparm".  I should have tho=
ught of
>> smartctl myself.
>>
>> Still no luck as yet - the smartctl on my test installation (Centos =
5.6)
>> doesn't seem to support megaraid devices.  But maybe that's just bec=
ause it
>> is an older version of smartctl - Centos 5.6 is not exactly "bleedin=
g edge".
>>
>
> Opps, sorry! I blame the medicine. You could try compile a version of
> smartctl yourself if you have the proper packages installed.
>

The CentOs installation is only temporary.  I was doing some testing=20
with IBM's software, which will only work on certain very specific Linu=
x=20
versions, such as various RHEL versions.  Since I like to use Debian on=
=20
servers (it's what I'm used to), I didn't fancy buying RHEL just to try=
=20
out the software - CentOS was a simple and convenient way to test the=20
software.  Once I get my "real" installation in place, I can make sure =
I=20
have up-to-date tools.

Thanks for your help and pointers,

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
