From: "Manibalan P" <pmanibalan@amiindia.co.in>
Subject: RE: raid6 - data intefrity issue - data mis-compare on rebuilding RAID 6 - with 100 Mb resync speed.
Date: Tue, 11 Mar 2014 18:52:00 +0530
Message-ID: <13688C12F44C7C428726663F950CA253094ADE12@venus.in.megatrends.com>
References: <13688C12F44C7C428726663F950CA253094ADAC5@venus.in.megatrends.com> <20140311140418.4eee07f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20140311140418.4eee07f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neal,

>I don't know what kernel "CentOS 6.4" runs.  Please report the actual
kernel version as well as distro details.
The Kernel version is : 2.6.32
 Centos  distribution  : 2.6.32-358.23.2.el6.x86_64 #1 SMP : x86_64
GNU/Linux

>I know nothing about "dit32" and so cannot easily interpret the output.
Is it saying that just a few bytes were wrong?

It is not just few bytes of corruption, it looks like some number of
sectors are corrupted (for example - 40 sectors ).  dit32 will write a
pattern of IO, and after each write cycle, it will read it back and
verify.
Actually, the data which is written on the reported LBA itself
corrupted. What I mean to say is,  this looks like write corruption.

>
>Was the array fully synced before you started the test?

Yes , IO is started, only after the re-sync is completed.
 And to add more info,
             I am facing this mis-compare only with high resync speed
(30M to 100M), I ran the same test with resync speed min -10M and max -
30M, without any issue. So the  issue has relationship with
sync_speed_max / min.

>
>I can't think of anything else that might cause an inconsistency.  I
test the
>RAID6 recovery code from time to time and it always works flawlessly
for me.

Do you suggest, any IO tool or test to ensure data integrity.

One more thing, I like to bring to your notification. I did the same IO
test on Ubuntu 13 (Linux ubuntu 3.8.0-19-generic #29-Ubuntu SMP Wed Apr
17 18:16:28 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux ) system also. And I
faced same type of data corruption.


Thanks,
Manibalan.


-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Tuesday, March 11, 2014 8:34 AM
To: Manibalan P
Cc: linux-raid@vger.kernel.org
Subject: Re: raid6 - data intefrity issue - data mis-compare on
rebuilding RAID 6 - with 100 Mb resync speed.

On Fri, 7 Mar 2014 14:18:59 +0530 "Manibalan P"
<pmanibalan@amiindia.co.in>
wrote:

> Hi,

Hi,
 when posting to vger.kernel.org lists, please don't send HTML mail,
just  plain text.
 Because you did the original email didn't get to the list.

> 
>  
> 
> We are facing a data integrity issue on RAID 6. On CentOS 6.4 kernel.

I don't know what kernel "CentOS 6.4" runs.  Please report the actual
kernel version as well as distro details.

> 
>  
> 
> Details of the setup:
> 
>  
> 
> 1.       7 drives Raid6 md devices (md0) - Capacity 25 GB
> 
> 2.       Resync speed max and min set to 100000 (100Mb)
> 
> 3.       A script is running to simulate drive failure, this script
will
> do the following
> 
> a.       Mdadm set faulty for two random drives on the md, the mdadm
> remove those drives.
> 
> b.      Mdadm add ond drive, and wait for rebuild to complete, then
> insert the next one.
> 
> c.       Wait till the md become optimal, and continue the disk
removal
> cycle again.
> 
> 4.       iSCSI target is configured to "/dev/md0"
> 
> 5.       From  Windows server, the md0 target is connected using
> MicroSoft iSCSI initiator, and formatted with NTFS.
> 
> 6.       Dit32 IO tool is running on the formatted volume.
> 
>  
> 
> Issue#:
> 
>                 The Dit32 tool will running IO in multiple threads, in

> each thread, IO will be written and verified.
> 
>                 And on the verification Cycle, we are getting 
> mis-compare. Below is the log from the dit32 tool.
> 
>                 
> 
> Thu Mar 06 23:19:31 2014 INFO:  DITNT application started
> 
> Thu Mar 06 23:20:19 2014 INFO:  Test started on Drive D:
> 
>      Dir Sets=8, Dirs per Set=70, Files per Dir=75
> 
>      File Size=512KB
> 
>      Read Only=N, Debug Stamp=Y, Verify During Copy=Y
> 
>      Build I/O Size range=1 to 128 sectors
> 
>      Copy Read I/O Size range=1 to 128 sectors
> 
>      Copy Write I/O Size range=1 to 128 sectors
> 
>      Verify I/O Size range=1 to 128 sectors
> 
> Fri Mar 07 01:28:09 2014 ERROR: Miscompare Found: File 
> "D:\dit\s6\d51\s6d51f37", offset=00048008
> 
>      Expected Data: 06 33 25 01 0240 (dirSet, dirNo, fileNo, 
> elementNo,
> sectorOffset)
> 
>          Read Data: 05 08 2d 01 0240 (dirSet, dirNo, fileNo, 
> elementNo,
> sectorOffset)
> 
>      Read Request: offset=00043000, size=00008600
> 
>  
> 
> This mail has been attached with the following files for your 
> reference
> 
> 1.       Raid5.c and .h files, the Code what we are using.
> 
> 2.       RollingHotSpareTwoDriveFailure.sh - the script which
simulates
> the two disk failure.
> 
> 3.       dit32log.sav - Log file from the dit32 tool
> 
> 4.       s6d31f37 - the file where the corruption happened(hex format)
> 
> 5.       CentOS-system-info - md and system info
> 
>  

I didn't find any "CentOS-system-info" attached.

I know nothing about "dit32" and so can not easily interpret the output.
Is it saying that just a few bytes were wrong?

Was the array fully synced before you started the test?

I can't think of anything else that might cause an inconsistency.  I
test the
RAID6 recovery code from time to time and it always works flawlessly for
me.

NeilBrown



> 
>                 
> 
> Thanks,
> 
> Manibalan.
> 
>  
> 

