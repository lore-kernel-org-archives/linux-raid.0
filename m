From: Mark Bellon <mbellon@mvista.com>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 12:44:09 -0700
Message-ID: <41F00A09.208@mvista.com>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu> <csotcs$oma$1@sea.gmane.org> <Pine.LNX.4.58.0501201142140.19586@lewis.et.byu.edu> <Pine.LNX.4.55.0501200909440.31637@umi.cfht.hawaii.edu> <Pine.LNX.4.58.0501201215420.19586@lewis.et.byu.edu> <Pine.LNX.4.55.0501200927000.31637@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0501200927000.31637@umi.cfht.hawaii.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: David Dougall <davidd@et.byu.edu>, Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kanoa Withington wrote:

>Ideally a different HBA altogether, but a different channel on a
>multichannel HBA at a minimum. If your SCSI card is not a multichannel
>card, think about getting one or think about a completely different
>arrangement.
>
>It may be possible to tune the HBA reset behavior or the XFS timeout
>threshold but as a matter of principle when constructing disk mirrors
>you should try to keep the disks as separate as possible. You should
>only need to tune, tweak or patch if you are trying to do something
>unusual - which you are not.
>  
>
Very true.

The default parameters for SCSI (5 retries as I recall) can take a very 
long time when a SCSI bus reset is called for (settle times and such) - 
I've seen 2+ minutes. Even with totally redundent controllers a logical 
I/O (to the RAID) could be held up waiting for a physical I/O by this 
long. The XFS parameter would need to be raised above the threadhold.

mark

>In the short term, unplug the failing disk:
>
>Jan 10 11:56:06 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0 lun 47
>
>You are better off without it if your system is crashing.
>
>-Kanoa
>
>
>
>On Thu, 20 Jan 2005, David Dougall wrote:
>
>  
>
>>By "different controller" do you mean HBA controller or disk controller?
>>The disk devices are on completely different jbods.  They are both through
>>the same HBA(the server only has 1 PCI slot)
>>--David Dougall
>>
>>
>>On Thu, 20 Jan 2005, Kanoa Withington wrote:
>>
>>    
>>
>>>Yes, that's a standard XFS timeout and shutdown. If your second disk
>>>is on the sme SCSI channel try moving it to a different one,
>>>preferably a different controller alotgether.
>>>
>>>Your disk 08:10 does have real problems, but they are separate from
>>>the XFS shutdown which should be prevented by the MD layer.
>>>
>>>-Kanoa
>>>
>>>On Thu, 20 Jan 2005, David Dougall wrote:
>>>
>>>
>>>      
>>>
>>>> return code = 8000002
>>>>Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
>>>>sense key
>>>> Hardware Error
>>>>Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 209453441
>>>>Jan 10 11:56:08 linux-sg2 kernel: I/O error in filesystem
>>>>("device-mapper(254,1)
>>>>") meta-data dev device-mapper(254,1) block 0x18fa318f
>>>>("xlog_iodone") err
>>>>or 5 buf count 2048
>>>>Jan 10 11:56:08 linux-sg2 kernel:
>>>>xfs_force_shutdown(device-mapper(254,1),0x2) c
>>>>alled from line 966 of file xfs_log.c.  Return address = 0xc0246d9b
>>>>Jan 10 11:56:08 linux-sg2 kernel: Filesystem "device-mapper(254,1)": Log
>>>>I/O Err
>>>>or Detected.  Shutting down filesystem: device-mapper(254,1)
>>>>Jan 10 11:56:08 linux-sg2 kernel: Please umount the filesystem, and
>>>>rectify the
>>>>problem(s)
>>>>
>>>>
>>>>I don't see any error messages from md in any of these logs.
>>>>--David Dougall
>>>>
>>>>
>>>>        
>>>>
>>>
>>>      
>>>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

