From: David Brown <david@westcontrol.com>
Subject: Re: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 16:04:23 +0200
Message-ID: <iok4of$eov$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/2011 15:25, Mathias Bur=C3=A9n wrote:
> On 19 April 2011 14:21, David Brown<david@westcontrol.com>  wrote:
>> I have recently got an IBM x3650 M3 server, which has a "Serveraid M=
5014"
>> raid controller.  Booting from a Linux CD (system rescue CD) and run=
ning
>> lspci identifies this raid controller as:
>>
>> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>>
>> The controller works fine for hardware raid - I can open its bios se=
tup
>> utility, and set up a RAID5 (or whatever) with the disks I have.  Th=
e OS
>> then just sees a single virtual disk.
>>
>> But I would like direct access to the sata drives - I want to set up=
 mdadm
>> raid, under my own control.  As far as I can see, there is no way to=
 put
>> this controller into "JBOD" or "direct access" mode of any sort.
>>
>> Does anyone here have experience with this card, or can give me any =
hints?
>>
>> The only idea I have at the moment is to put each disk within its ow=
n
>> single-disk RAID 0 set, but then I don't get sata hot-swap functiona=
lity,
>> SMART, hddtemp, etc.
>>
>> Thanks for any clues or hints,
>>
>> David
>>
>
> Regarding SMART, could you try (after loading the appropriate
> megaraid/megasas module) hdparm -a -d megaraid,$I /dev/sda , where $I
> is a number between 0 and 31 IIRC (depending on the HDD in the array)=
=2E
>

Are you sure about the syntax for that command?  Trying that with "0"=20
for $I just gives me "megaraid,0: No such file or directory".  As far a=
s=20
I can see, the megaraid module is loaded (lsmod shows "megaraid_sas" in=
=20
the modules list).

Thanks anyway,

David


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
