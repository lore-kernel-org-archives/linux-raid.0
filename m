From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Thu, 14 Apr 2011 14:12:01 -0700 (PDT)
Message-ID: <270234.74664.qm@web65113.mail.ac2.yahoo.com>
References: <4DA6F3B4.7040303@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA6F3B4.7040303@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?iso-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 15/4/11, Phil Turmel <philip@turmel.org> wrote:

> From: Phil Turmel <philip@turmel.org>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: "Mathias Bur=E9n" <mathias.buren@gmail.com>, neilb@suse.de, linux=
-raid@vger.kernel.org
> Date: Friday, 15 April, 2011, 1:16
> Hi Gavin,
>=20
> I think you might want to investigate your *power supply*
> ...
>=20
> On 04/13/2011 08:15 PM, Gavin Flower wrote:
>=20
> [snip /]
>=20
> > SMART Attributes Data Structure revision number: 10
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME=A0 =A0 =A0 =A0 =A0
> FLAG=A0 =A0=A0=A0VALUE WORST THRESH TYPE=A0
> =A0 =A0 UPDATED=A0 WHEN_FAILED RAW_VALUE
> >=A0=A0=A01 Raw_Read_Error_Rate=A0
> =A0=A0=A00x000f=A0=A0=A0115=A0=A0=A0099=A0=A0=A0006=A0
> =A0 Pre-fail=A0 Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A087918991
> >=A0=A0=A03 Spin_Up_Time=A0 =A0 =A0
> =A0 =A0 =A0
> 0x0003=A0=A0=A0099=A0=A0=A0097=A0=A0=A0000=A0
> =A0 Pre-fail=A0 Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A00
> >=A0=A0=A04 Start_Stop_Count=A0 =A0
> =A0 =A0
> 0x0032=A0=A0=A0085=A0=A0=A0085=A0=A0=A0020=A0
> =A0 Old_age=A0=A0=A0Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A016014
> >=A0=A0=A05
> Reallocated_Sector_Ct=A0=A0=A00x0033=A0=A0=A0100=A0=A0=A0100=A0=A0=A0=
036=A0
> =A0 Pre-fail=A0 Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A00
> >=A0=A0=A07 Seek_Error_Rate=A0 =A0 =A0
> =A0=A0=A00x000f=A0=A0=A0072=A0=A0=A0060=A0=A0=A0030=A0
> =A0 Pre-fail=A0 Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A020251386
> >=A0=A0=A09 Power_On_Hours=A0 =A0 =A0
> =A0 =A0
> 0x0032=A0=A0=A0097=A0=A0=A0097=A0=A0=A0000=A0
> =A0 Old_age=A0=A0=A0Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A02940
> >=A0 10 Spin_Retry_Count=A0 =A0 =A0 =A0
> 0x0013=A0=A0=A0100=A0=A0=A0100=A0=A0=A0097=A0
> =A0 Pre-fail=A0 Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A00
> >=A0 12 Power_Cycle_Count=A0 =A0
> =A0=A0=A00x0032=A0=A0=A0093=A0=A0=A0093=A0=A0=A0020=A0
> =A0 Old_age=A0=A0=A0Always=A0 =A0
> =A0=A0=A0-=A0 =A0 =A0=A0=A07999
>=20
> SMOKING GUN=A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0
> ^^^^
>=20
> I suspect your power supply is good enough to slowly spin
> up your drives and get them talking, but when you ask them
> to work hard, especially when writing, the PS voltage dips
> enough to reset the drive.
>=20
> Look up all the power consumption specs for all of your
> components, and add up the *peak* current
> requirements.=A0 Make sure your PS can handle it.
>=20
> HTH,
>=20
> Phil
>=20

Hi Phil,

I was under the impression that I had an adequate power supply, so I ch=
ecked all 5 drives.  In fact I made a table to compare all the smart en=
tries.  The differences I thought were significant follow later.  I hav=
e the full comparison table, and the original smart output, in an OpenD=
ocument file - which I will attach to a separate email (in case it gets=
 blocked/dropped or some such).

Note that Power_Cycle_Count is anomalous only for /dev/sdc, so would th=
is suggest cable problems?

I am not sure what to make of the other discrepancies.

Note that sda, sdb, sdd, & sde were bought and put in at the same time,=
 while sdc was only obtained and inserted recently.

  sda      sdb      sdc      sdd      sde
  4 Start_Stop_Count
  720      716    16021    65535      713

  5 Reallocated_Sector_Ct
   17       42        0        1       79

  9 Power_On_Hours
12505    12500     2960    12405    12475

 12 Power_Cycle_Count
  720      716     7999      719      713
 =20
188 Command_Timeout
 1040        1        1        0        4
=20
189 High_Fly_Writes
    1        0        0        0        0
   =20
Only /dev/sda has any errors logged, the 6th error occurred at disk pow=
er-on lifetime 12416 hours (517 days + 8 hours)

  When the command that caused the error occurred, the device was activ=
e or idle.



  After command completion occurred, registers were:

  ER ST SC SN CL CH DH

  -- -- -- -- -- -- --

  40 51 00 26 52 c2 0c



  Commands leading to the command that caused the error were:

  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name

  -- -- -- -- -- -- -- --  ----------------  --------------------

  60 00 a8 97 51 c2 4c 00      00:07:58.408  READ FPDMA QUEUED

  60 00 00 3f 52 c2 4c 00      00:07:58.407  READ FPDMA QUEUED

  60 00 00 3f 53 c2 4c 00      00:07:58.407  READ FPDMA QUEUED

  60 00 28 3f 54 c2 4c 00      00:07:58.407  READ FPDMA QUEUED

  60 00 18 67 54 c2 4c 00      00:07:58.407  READ FPDMA QUEUED


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
