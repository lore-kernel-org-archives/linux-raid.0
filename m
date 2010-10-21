From: Tim Small <tim@seoss.co.uk>
Subject: Re: problems with "LSISAS2008 6Gb/s SAS" kernel mpt2sas driver
Date: Thu, 21 Oct 2010 12:08:51 +0100
Message-ID: <4CC01F43.8010003@seoss.co.uk>
References: <20101021073159.GA30734@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101021073159.GA30734@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-poweredge@dell.com" <linux-poweredge@dell.com>
List-Id: linux-raid.ids

On 21/10/10 08:31, Louis-David Mitterrand wrote:
> Hi,
>
> I am setting up a new Dell T610 server with 8 WD Black Caviar sata3 1TB
> disks on a LSISAS2008 controller:
>
> 	Oct 21 09:12:37 grml kernel: [   83.377388] mpt2sas0: LSISAS2008: FWVersion(02.1
> 5.63.00), ChipRevision(0x02), BiosVersion(07.01.09.00)
>
> My layout is as follows:
>
> - small un-encrypted raid1 boot partition on /dev/md0
>
> - dm-crypt main partition on /dev/md1 (actuallly /dev/mapper/cmd1)
>
> A recent grml64 is used to create the partitions, install the system and
> run lilo.
>
> When running lilo I get these errors from the controller:
>
> 	Oct 21 08:57:11 grml kernel: [40832.015207] mpt2sas0: fault_state(0x265d)!
> 	Oct 21 08:57:11 grml kernel: [40832.015210] mpt2sas0: sending diag reset !!
>    


> Any suggestion on fixing that problem would be welcome. I can send more
> complete logs.
>    

Looks like a firmware bug - do you have the latest firmware?  Drive 
firmwares?  Anything in the drive error logs (using smartctl)?

If not, then try opening a bug on the kernel bugzilla - LSI engineers 
read that (and sometimes even fix things).

Otherwise, you could try replacing with a straight SATA contoller, if 
that box doesn't have a SAS backplane - I've not been to impressed by 
the quality of engineering for LSI contollers, and SATA-on-SAS in 
general hasn't been very reliable IMO.  Just go for a well supported 
SATA controller (e.g. Sil 3132 etc.).

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

