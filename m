From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 14:25:21 +0100
Message-ID: <BANLkTi=psjvW5Lj=sr93E5caMxDAMm67JQ@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iok28i$tp6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 April 2011 14:21, David Brown <david@westcontrol.com> wrote:
> I have recently got an IBM x3650 M3 server, which has a "Serveraid M5=
014"
> raid controller. =C2=A0Booting from a Linux CD (system rescue CD) and=
 running
> lspci identifies this raid controller as:
>
> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>
> The controller works fine for hardware raid - I can open its bios set=
up
> utility, and set up a RAID5 (or whatever) with the disks I have. =C2=A0=
The OS
> then just sees a single virtual disk.
>
> But I would like direct access to the sata drives - I want to set up =
mdadm
> raid, under my own control. =C2=A0As far as I can see, there is no wa=
y to put
> this controller into "JBOD" or "direct access" mode of any sort.
>
> Does anyone here have experience with this card, or can give me any h=
ints?
>
> The only idea I have at the moment is to put each disk within its own
> single-disk RAID 0 set, but then I don't get sata hot-swap functional=
ity,
> SMART, hddtemp, etc.
>
> Thanks for any clues or hints,
>
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Regarding SMART, could you try (after loading the appropriate
megaraid/megasas module) hdparm -a -d megaraid,$I /dev/sda , where $I
is a number between 0 and 31 IIRC (depending on the HDD in the array).

Regards,
M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
