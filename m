From: Frank Behner <frank@behner.org>
Subject: Re: HA with qlogic FC and linux raid
Date: Mon, 20 Jan 2003 23:13:24 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E2C7484.4030707@behner.org>
References: <1042980305.3e2a9dd18c42a@secure.private.behner.org> <3E2C4B47.2090004@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

only if all pathes are dead. I did in the meantime change multipath.c so 
that in those cases the path/disk is marked bad. Now the Oops has gone. 
But I still have a SCSI error in the logs which I could not yet identify 
who is sending it. The log entries are for example:
Jan 15 18:30:01 dmslsp1 kernel: SCSI disk error : host 1 channel 0 id 0 
lun 0 re
turn code = 20008
Jan 15 18:30:01 dmslsp1 kernel:  I/O error: dev 08:11, sector 9379848
And of course main sympthoms I/O is hanging machine does not cleanly 
shutdown stay.
Can you point me whether I have to look for this in the raidtools, in 
the driver or in the mid-scsi code.
BTW the kernel is 2.4.19 with a SuSE SLES8 distribution.

    By Frank


Steven Dake schrieb:

> Do you see an OOPS when one of the paths of the multipath leaves, or 
> only when all paths are dead or in LIP.
>
> Thanks
> -steve
>
> frank@behner.org wrote:
>
>> Hi,
>>
>> We try to build a HA environment for a Document Management System. 
>> Before I come
>> to the problem I will briefly describe our setup. We have two 
>> buildings and a
>> fibrechannel switch in each building and attached to it a disk 
>> arrays, a DB
>> server for the metadata (Linux with Oracle) and a fileserver under 
>> W2K for the
>> bulk data. The fileserver runs under W2K, because the application 
>> server runs
>> under W2K. The servers are also connected to the switch in the other 
>> building.
>> The idea is to mirror the data over the buildings. All machines are 
>> connected
>> with two fibres (using QLA2202F cards) to each switch. Also the 
>> arrays are using
>> two connections to the switch. is true for. So we have a multiple 
>> pathes from
>> the machines to the arrays.
>>
>> The Linux machines are using md-raidtools to mirror over the 
>> buildings. To see
>> the correct number of devices we have used first the failover qlogic 
>> driver 6.01
>> and afterwards the standard version upto 6.04beta4 with the multipath
>> personality of the mdtools.
>>
>> The system runs till we need the failover. But if pathes are not 
>> available we
>> get a kernel Oops in the RAID1 personality of the md and any IO to 
>> the disk
>> arrays hangs forever, the machine does also not shutdown correctly. 
>> Because we
>> see this behaviour also if a windows machine boots and sends a LIP 
>> reset over
>> the fibre channel, this is even for normal operations not acceptable. 
>> Needless
>> to say that the W2K do not have this problem. Therefore we concluded 
>> that the
>> setup of the hardware is ok,(BIOS settings are the same for Linux and 
>> W2K). Of
>> course we are unsure whether the problem is in the mdtools or in the 
>> qlogic
>> driver (who should handle the LIP reset). We try to get help from Linux
>> companies, but we where not very successful.I could send the list 
>> Oops and more
>> information if it would help. Maybe it is well known problem having a 
>> raid1
>> personality over two multipath personalities. (The Oops says 
>> something from a
>> NULL pointer which he can't follow and if I understood it correctly, 
>> it happens
>> after all pathes are gone, due to LIP reset). The LIP reset problem 
>> was first
>> seen while the mirror was resyncing and a windows machine got rebooted.
>>
>> Thank you for some feedback
>>     Frank Behner
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>  
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



