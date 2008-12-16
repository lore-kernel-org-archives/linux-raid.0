From: Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: [smartmontools-support] Velociraptor biting the dust (9th disk,
 continued to use it, and..)
Date: Tue, 16 Dec 2008 07:16:14 -0600 (CST)
Message-ID: <Pine.LNX.4.64.0812160708140.9136@gc.phys.uwm.edu>
References: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan>
 <20081122215529.1973f820@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0812160625150.8812@gc.phys.uwm.edu>
 <alpine.DEB.1.10.0812160803170.725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812160803170.725@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>, Alan Piszcz <ap@solarrain.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-raid.ids

>>>> [632714.975844] ata1.00: status: { DRDY ERR }
>>>> [632714.975847] ata1.00: error: { IDNF }

>>> IDNF - ID not found, usually these days means 'asked for a sector out of
>>> range'

>> Justin, was this error provoked for example by you using a 'dd' command to
>> try and read stuff past the end of the disk?  Because the md device driver
>> should not try and do something like that.  The md device driver knows how
>> many LBAs are available on the disk and should never issue a read or write
>> past the end of the device.
>>
>> Justin, I have the impression that this IDNF error was NOT due to you issuing
>> dd commands or similar, but was part of 'normal' md operation.
>>
>> Alan, am I overlooking something?  (One feature that might provide such
>> errors is the 'host reserved address' set of commands that allow you to
>> 'clip' the disk capacity.)

> Most of the errors were during normal md/Linux operation.  However, I will
> also note that with a 16-port 3ware controller, drives were also
> having problems, different errors mind you but they were rather nasty.
>
> The errors occured on RAID-1, RAID-5 and RAID-6 and even on a single disk,
> no md/Linux, I kept running bonnie++ with different filesystems on one
> disk, ext3 and XFS, both of which started erroring out.

When you say 'the errors occured' do you mean specifically the 'IDNF' 
errors?  Those are the onces I am talking about.  I am NOT talking about 
other types of errors like UNC or ABORT.  I am ONLY talking about the IDNF 
errors.

> I removed all of the Velociraptors and replaced them with good old
> Raptor150s and tested with md/Linux and the 3ware card, no problems with
> either configuration.  I truly believe something is wrong with the
> Velociraptors at this point since both md/Linux and 3ware both had problems
> with the drives.

It is easy to check if the IDNF errors are from the disk firmware or 
the Linux kernel.

The kernel error message for IDNF should report the LBA which provoked 
that IDNF error.  Please compare that with the maximum LBA on the disk, 
which you can get either via hdparm or smartctl -i (divide total capacity 
in bytes by 512).

If the LBA reported in the kernel error message is greater than the 
maximum LBA on the disk, then the problem is in the Linux kernel.  If the 
LBA reported by the kernel is less than the maximum LBA on the disk, then 
the problem is the disk firmware (or perhaps the disk has its capacity 
'clipped' with the 'Host Protected Area' feature set.  But the Linux 
kernel should know about this, so that would be a kernel bug again, not a 
disk firmware bug).

Cheers,
     Bruce
