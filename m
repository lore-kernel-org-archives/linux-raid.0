From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Thu, 29 Jul 2010 21:24:52 -0700
Message-ID: <AANLkTikTzbE4L458a1HGOZ=gQPt7Y5V_QbeSZKMduspq@mail.gmail.com>
References: <4C506CF5.2080307@xunil.at>
	<4C5079C4.2050308@seoss.co.uk>
	<4C5092C4.6050708@gmx.net>
	<20100729031100.69f583d7@natsu>
	<AANLkTinDLyQPdRwx6e=Qx71rnTOAS093Az0EEr_v5+NL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinDLyQPdRwx6e=Qx71rnTOAS093Az0EEr_v5+NL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 28, 2010 at 7:50 PM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:

>
> I am waiting for this drive to get to the point that Seagate will acc=
ept an RMA:
>
> ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRESH=
 TYPE
> UPDATED =A0WHEN_FAILED RAW_VALUE
> =A01 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 089 =A0 076 =A0 006 =A0 =A0=
Pre-fail
> Always =A0 =A0 =A0 - =A0 =A0 =A0 173224741
> =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 094 =A0 093 =A0 0=
00 =A0 =A0Pre-fail
> Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020 =A0=
 =A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 69
> =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0=
Pre-fail
> Always =A0 =A0 =A0 - =A0 =A0 =A0 2002
> =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 046 =A0 036 =A0 030 =A0=
 =A0Pre-fail
> Always =A0 =A0 =A0 - =A0 =A0 =A0 42786857552386
> =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 082 =A0 082 =A0 000=
 =A0 =A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 16170
> =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 097 =
=A0 =A0Pre-fail
> Always =A0 =A0 =A0 - =A0 =A0 =A0 5
> =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =A0=
 =A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 69
> 184 Unknown_Attribute =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 099 =A0 =
=A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 012 =A0 012 =A0 000 =A0 =
=A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 88
> 188 Unknown_Attribute =A0 =A0 =A0 0x0032 =A0 100 =A0 090 =A0 000 =A0 =
=A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 112
> 189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =A0=
 =A0Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 190 Airflow_Temperature_Cel 0x0022 =A0 064 =A0 057 =A0 045 =A0 =A0Old=
_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 36 (Lifetime Min/Max 33/43)
> 194 Temperature_Celsius =A0 =A0 0x0022 =A0 036 =A0 043 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 36 (0 10 0 0)
> 195 Hardware_ECC_Recovered =A00x001a =A0 031 =A0 020 =A0 000 =A0 =A0O=
ld_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 173224741
> 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0O=
ld_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0O=
ld_age
> Offline =A0 =A0 =A0- =A0 =A0 =A0 0
> 199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =A0=
Old_age
> Always =A0 =A0 =A0 - =A0 =A0 =A0 0
>
>
> It is a desktop drive and is used for half of several =A0RAID1 arrays=
,
> but so far it hasn't been kicked out of any arrays. I have run a chec=
k
> several times in the last few days. =A0I had expected it to show a
> failing state when the reallocated sector count reached 2000, but it
> hasn't.


Well, despite the S.M.A.R.T. data showing that the drive is OK, it has
apparently totally failed this evening. The disk is totally
inaccessible

=46rom the logs:
Jul 29 20:39:56 server2 kernel: ata1: failed to read log page 10h (errn=
o=3D-5)
Jul 29 20:40:48 server2 kernel: ata1.00: exception Emask 0x1 SAct
0x403ffff7 SErr 0x0 action 0x0
Jul 29 20:40:48 server2 kernel: ata1.00: irq_stat 0x40000008
Jul 29 20:40:48 server2 kernel: ata1.00: cmd
60/80:00:e8:2b:5a/00:00:47:00:00/40 tag 0 ncq 65536 in
Jul 29 20:40:48 server2 kernel:          res
40/00:a8:e8:35:5a/3a:00:47:00:00/40 Emask 0x1 (device error)
Jul 29 20:40:48 server2 kernel: ata1.00: status: { DRDY }
Jul 29 20:40:48 server2 kernel: ata1.00: cmd
60/80:08:e8:2f:5a/00:00:47:00:00/40 tag 1 ncq 65536 in
Jul 29 20:40:48 server2 kernel:          res
40/00:a8:e8:35:5a/00:00:47:00:00/40 Emask 0x1 (device error)
Jul 29 20:40:48 server2 kernel: ata1.00: status: { DRDY }
Jul 29 20:40:48 server2 kernel: ata1.00: cmd
60/80:10:e8:33:5a/00:00:47:00:00/40 tag 2 ncq 65536 in
Jul 29 20:40:48 server2 kernel:          res
40/00:a8:e8:35:5a/00:00:47:00:00/40 Emask 0x1 (device error)
=2E..
Jul 29 20:40:48 server2 kernel: ata1.00: status: { DRDY }
Jul 29 20:40:48 server2 kernel: ata1.00: qc timeout (cmd 0xec)
Jul 29 20:40:48 server2 kernel: ata1.00: failed to IDENTIFY (I/O
error, err_mask=3D0x5)
Jul 29 20:40:48 server2 kernel: ata1.00: revalidation failed (errno=3D-=
5)
Jul 29 20:40:48 server2 kernel: ata1: hard resetting link
Jul 29 20:40:48 server2 kernel: ata1: SATA link up 3.0 Gbps (SStatus
123 SControl 300)
Jul 29 20:40:48 server2 kernel: ata1.00: qc timeout (cmd 0xa1)
Jul 29 20:40:48 server2 kernel: ata1.00: failed to IDENTIFY (I/O
error, err_mask=3D0x5)
Jul 29 20:40:48 server2 kernel: ata1.00: revalidation failed (errno=3D-=
5)
Jul 29 20:40:48 server2 kernel: ata1: limiting SATA link speed to 1.5 G=
bps
Jul 29 20:40:48 server2 kernel: ata1: hard resetting link
Jul 29 20:40:48 server2 kernel: ata1: SATA link up 1.5 Gbps (SStatus
113 SControl 310)
Jul 29 20:40:48 server2 kernel: ata1.00: qc timeout (cmd 0xa1)
Jul 29 20:40:48 server2 kernel: ata1.00: failed to IDENTIFY (I/O
error, err_mask=3D0x5)
Jul 29 20:40:48 server2 kernel: ata1.00: revalidation failed (errno=3D-=
5)
Jul 29 20:40:48 server2 kernel: ata1.00: disabled
Jul 29 20:40:48 server2 kernel: ata1: hard resetting link
Jul 29 20:40:48 server2 kernel: ata1: SATA link up 1.5 Gbps (SStatus
113 SControl 310)
Jul 29 20:40:48 server2 kernel: ata1: EH complete
Jul 29 20:40:48 server2 kernel: sd 0:0:0:0: [sda] Unhandled error code
Jul 29 20:40:48 server2 kernel: sd 0:0:0:0: [sda] Result:
hostbyte=3D0x04 driverbyte=3D0x00
Jul 29 20:40:48 server2 kernel: end_request: I/O error, dev sda,
sector 1197091688


I guess Seagate will accept it for an RMA now!

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
