From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Tue, 8 Feb 2011 16:31:24 -0200
Message-ID: <AANLkTi=sgTjGMvNiZB2aqxpe8-z7V0bUks84+fMxCAoY@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D517F4F.4060003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it's resync running?
i don't think it's a problem...
any device will die some day...
ssd is faster than hd, why not use it?
i'm using hp smart array p212 with 3.0 firmware, it write on all blocks=
 too
maybe a just command line option to start array without sync could help=
=2E..
i don't know if resync is write intensive or just write on diferent
blocks, if it's just diff it's not a problem for ssd...

again...
i know that the 'translate' of trim command to non compatible devices
is a problem for device layer not md layer, but can md send trim
command to all mirrors/disks?

2011/2/8 maurice <mhilarius@gmail.com>:
> On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>>
>> hi guys, could md send TRIM command to ssd? using ext4 discart mount
>> option?
>> if i mix ssd and hd, could this TRIM be rewrite to non TRIM compatib=
le
>> disks?
>>
> I have read that using md with SSDs is not a great idea:
> Form the Fedora 14 documentation:
>
> "Take note as well that software RAID levels 1, 4, 5, and 6 are not
> recommended for use on SSDs.
> During the initialization stage of these RAID levels, some RAID manag=
ement
> utilities (such as mdadm)
> write to all of the blocks on the storage device to ensure that check=
sums
> operate properly.
> This will cause the performance of the SSD to degrade quickly. "
>
> https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administr=
ation_Guide/newmds-ssdtuning.html
>
>
> --
> Cheers,
> Maurice Hilarius
> eMail: /mhilarius@gmail.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
