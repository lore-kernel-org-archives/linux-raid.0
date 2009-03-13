From: David Rees <drees76@gmail.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 11:42:43 -0700
Message-ID: <72dbd3150903131142q1da9c98dr3838eef1d5fd0970@mail.gmail.com>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
	 <20090313004802.GB29989@mint.phcomp.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090313004802.GB29989@mint.phcomp.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Alain Williams <addw@phcomp.co.uk>
Cc: Ryan Wagoner <rswagoner@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 12, 2009 at 5:48 PM, Alain Williams <addw@phcomp.co.uk> wro=
te:
> I suspect that the answer is 'no', however I am seeing problems with =
raid 1
> on CentOS 5.2 x86_64. The system worked nicely for some 2 months, the=
n apparently
> a disk died and it's mirror appeared to have problems before the firs=
t could be
> replaced. The motherboard & both disks have now been replaced (data s=
aved with a bit
> of luck & juggling). I have been assuming hardware, but there seems l=
ittle else
> to change... and you report long I/O waits that I saw and still see
> (even when I don't see the kernel error messages below).
>
> Disks have been Seagate & Samsung, but now both ST31000333AS (1TB) as=
 raid 1.
> Adaptec AIC7902 Ultra320 SCSI adapter
> aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI-X 101-133Mhz, 512 =
SCBs

Uh, how are you using SATA disks on a SCSI controller?

> I am seeing this sort of thing in /var/log/messages:
> Mar 12 09:21:58 BFPS kernel: ata2.00: exception Emask 0x0 SAct 0x0 SE=
rr 0x0 action 0x2 frozen
> Mar 12 09:21:58 BFPS kernel: ata2.00: cmd ea/00:00:00:00:00/00:00:00:=
00:00/a0 tag 0
> Mar 12 09:21:58 BFPS kernel: =A0 =A0 =A0 =A0 =A0res 40/00:00:00:4f:c2=
/00:00:00:00:00/00 Emask 0x4 (timeout)
> Mar 12 09:21:58 BFPS kernel: ata2.00: status: { DRDY }
> Mar 12 09:22:03 BFPS kernel: ata2: port is slow to respond, please be=
 patient (Status 0xd0)
> Mar 12 09:22:08 BFPS kernel: ata2: device not ready (errno=3D-16), fo=
rcing hardreset
> Mar 12 09:22:08 BFPS kernel: ata2: hard resetting link
> Mar 12 09:22:08 BFPS kernel: ata2: SATA link up 3.0 Gbps (SStatus 123=
 SControl 300)
> Mar 12 09:22:39 BFPS kernel: ata2.00: qc timeout (cmd 0xec)
> Mar 12 09:22:39 BFPS kernel: ata2.00: failed to IDENTIFY (I/O error, =
err_mask=3D0x5)
> Mar 12 09:22:39 BFPS kernel: ata2.00: revalidation failed (errno=3D-5=
)
> Mar 12 09:22:39 BFPS kernel: ata2: failed to recover some devices, re=
trying in 5 secs
> Mar 12 09:22:44 BFPS kernel: ata2: hard resetting link

You are experiencing one of the following:

Drive failure
Cabling failure
Controller failure
Buggy drive firmware
Buggy drivers

BTW, the ST31000333AS is one of the drives that were shipped with
buggy firmware causing timeouts like the ones you are seeing.  You
should check with Seagate that you have the latest firmware flashed to
those drives.

> Mar 12 09:28:07 BFPS smartd[3183]: Device: /dev/sdb, not capable of S=
MART self-check
> Mar 12 09:28:07 BFPS smartd[3183]: Sending warning via mail to root .=
=2E.
> Mar 12 09:28:07 BFPS smartd[3183]: Warning via mail to root: successf=
ul

You really need to get SMART checking working as well.  Checking the
status of the drive (try smartctl) may help you isolate your problem.

Which, BTW, does not appear to be the same as the thread starter's.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
