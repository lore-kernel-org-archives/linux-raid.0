From: "Majed B." <majedb@gmail.com>
Subject: Re: raid1 running fine for years .. and then
Date: Fri, 9 Oct 2009 20:58:02 +0300
Message-ID: <70ed7c3e0910091058u601a0b1dkf40ada4c5abda6a3@mail.gmail.com>
References: <alpine.DEB.2.00.0910072350440.30153@p34.internal.lan>
	<alpine.DEB.2.00.0910091353140.3264@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910091353140.3264@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Change the SATA cable.

On Fri, Oct 9, 2009 at 8:53 PM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>
>
> On Wed, 7 Oct 2009, Justin Piszcz wrote:
>
>> Hello,
>>
>> I have 2 disks + 1 spare (3 total) in a raid-1 configuration, over t=
he
>> past
>> 3-4 weeks after 1-2 year of raid-1 (md), this is the second time thi=
s has
>> happened:
>>
>> [1538654.702201] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 acti=
on 0x6
>> frozen
>> [1538654.702209] ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 ta=
g 0
>> [1538654.702210] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:3c:4=
f:c2/00:00:00:00:00/00 Emask
>> 0x4 (timeout)
>> [1538654.702213] ata1.00: status: { DRDY }
>> [1538654.702217] ata1: hard resetting link
>> [1538660.012018] ata1: link is slow to respond, please be patient
>> (ready=3D0)
>> [1538664.704019] ata1: COMRESET failed (errno=3D-16)
>> [1538664.704024] ata1: hard resetting link
>> [1538670.058008] ata1: link is slow to respond, please be patient
>> (ready=3D0)
>> [1538674.750009] ata1: COMRESET failed (errno=3D-16)
>> [1538674.750015] ata1: hard resetting link
>> [1538680.104031] ata1: link is slow to respond, please be patient
>> (ready=3D0)
>> [1538692.344014] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 3=
00)
>> [1538692.348906] ata1.00: configured for UDMA/133
>> [1538692.348929] ata1: EH complete
>> [1538692.362731] end_request: I/O error, dev sdb, sector 293041531
>> [1538692.362737] md: super_written gets error=3D-5, uptodate=3D0
>> [1538692.362741] raid1: Disk failure on sdb3, disabling device.
>>
>> The smart statistics on the disk all show as OK and the short+long t=
ests
>> run successfully.
>>
>> Anyone know what is going on here?
>>
>> rm --read-sector 293041531 /dev/sdb
>>
>> /dev/sdb:
>> reading sector 293041531: succeeded
>> ..
>> ..
>> < the data / numbers >
>>
>> The last time this happened, I wrote the disk with zeroes/badblocks/=
etc
>> and failed/removed then re-added it to the array without any issues,=
 now,
>> 3-4 weeks later, it has happened again.
>>
>> Justin.
>>
>
> Any thoughts/ideas?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
