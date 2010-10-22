From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: problems with "LSISAS2008 6Gb/s SAS" kernel mpt2sas driver
Date: Fri, 22 Oct 2010 07:25:13 +0200
Message-ID: <4CC12039.4010503@stud.tu-ilmenau.de>
References: <20101021073159.GA30734@apartia.fr> <4CC01F43.8010003@seoss.co.uk>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CC01F43.8010003@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-poweredge@dell.com" <linux-poweredge@dell.com>
List-Id: linux-raid.ids

Am 21.10.2010 13:08, schrieb Tim Small:
> On 21/10/10 08:31, Louis-David Mitterrand wrote:
>> Hi,
>>
>> I am setting up a new Dell T610 server with 8 WD Black Caviar sata3 1TB
>> disks on a LSISAS2008 controller:
>>
>>     Oct 21 09:12:37 grml kernel: [   83.377388] mpt2sas0: LSISAS2008:
>> FWVersion(02.1
>> 5.63.00), ChipRevision(0x02), BiosVersion(07.01.09.00)
>>
>> My layout is as follows:
>>
>> - small un-encrypted raid1 boot partition on /dev/md0
>>
>> - dm-crypt main partition on /dev/md1 (actuallly /dev/mapper/cmd1)
>>
>> A recent grml64 is used to create the partitions, install the system and
>> run lilo.
>>
>> When running lilo I get these errors from the controller:
>>
>>     Oct 21 08:57:11 grml kernel: [40832.015207] mpt2sas0:
>> fault_state(0x265d)!
>>     Oct 21 08:57:11 grml kernel: [40832.015210] mpt2sas0: sending diag
>> reset !!
>>    
> 
> 
>> Any suggestion on fixing that problem would be welcome. I can send more
>> complete logs.
>>    
> 
> Looks like a firmware bug - do you have the latest firmware?  Drive
> firmwares?  Anything in the drive error logs (using smartctl)?
> 
> If not, then try opening a bug on the kernel bugzilla - LSI engineers
> read that (and sometimes even fix things).
> 
> Otherwise, you could try replacing with a straight SATA contoller, if
> that box doesn't have a SAS backplane - I've not been to impressed by
> the quality of engineering for LSI contollers, and SATA-on-SAS in
> general hasn't been very reliable IMO.  Just go for a well supported
> SATA controller (e.g. Sil 3132 etc.).
> 
> Tim.
> 
> 
I'll have to object on the matter of SATA-drives on SAS-controllers.  We
use 3ware/LSI 9650,9690 and 9750 controllers a lot and have rarely had
any problems.  The problems we encountered came with hardware failures.
On the LSISAS2008 it's good to hear that most problems got fixed with
later kernels.  As we are trying to get our lower-cost storage systems
running on this controller (onboard a supermicro MB), this shows which
way to go... Thank you for this information!

Stefan
