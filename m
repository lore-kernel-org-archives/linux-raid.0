From: rob <rob@fantinibakery.com>
Subject: Re: raid0 and iscsi
Date: Mon, 13 Oct 2003 08:14:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8A9736.1020706@fantinibakery.com>
References: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu>
To: Jayshankar Nair <jshankar@CS.ColoState.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
 What kind of network are you uasing for the data transfer?

 The rest of post does not answer your specific questions, but is to 
show the transfer speeds on our network to backup servers using hardware 
and software raid.  

 Both systems use Mandrake 9.1.  network is a fast-lan. speed 100.

Bkup1 is scsi with Mylex hardware raid, athlon 1800 cpu.  array has 4  
9-gb lvd disks.

Bkup2 is a new test server using software raid.  dual 750 intel xeon,  
4- 9-gb se scsi disks.

 I transfer data 30-40 times per day to each server.  500-mb hourly on 
the average. ususal tme is less than a min.
 The test uses rsync to transfer data.  rsync uses a lot of cpu so the 
speed difference may be more due to cpu than the difference of raid type.

 the command used: rsync -e ssh -a --stats  /bkup3/  fbc5:/bkup3/

here is the result of sending approx 3-gb of data to each:
 
-------------------------------------------------
 this is the output of an rsync transfer to the backup software-raid server:

Mon Oct 13 07:36:41 EDT 2003
rsync[21832] (sender) heap statistics:
  arena:        7996056   (bytes from sbrk)
  ordblks:           59   (chunks not in use)
  smblks:             2
  hblks:              1   (chunks from mmap)
  hblkhd:        516096   (bytes from mmap)
  usmblks:            0
  fsmblks:           80
  uordblks:     7821736   (bytes used)
  fordblks:      174320   (bytes free)
  keepcost:      128840   (bytes in releasable chunk)

Number of files: 65699
Number of files transferred: 45739
Total file size: 2707740663 bytes
Total transferred file size: 2707630760 bytes
Literal data: 2707630760 bytes
Matched data: 0 bytes
File list size: 1,925,417
Total bytes written: 2,711,680,565
Total bytes read: 731844

wrote 2711680565 bytes  read 731844 bytes  5,046,348.67 bytes/sec
total size is 2707740663  speedup is 1.00
Mon Oct 13 07:45:38 EDT 2003

------------------------------------
to the hardware raid server:
Mon Oct 13 07:23:19 EDT 2003
rsync[19963] (sender) heap statistics:
  arena:        7996056   (bytes from sbrk)
  ordblks:           59   (chunks not in use)
  smblks:             2
  hblks:              1   (chunks from mmap)
  hblkhd:        516096   (bytes from mmap)
  usmblks:            0
  fsmblks:           80
  uordblks:     7821736   (bytes used)
  fordblks:      174320   (bytes free)
  keepcost:      128840   (bytes in releasable chunk)

Number of files: 65699
Number of files transferred: 45739
Total file size: 2707740663 bytes
Total transferred file size: 2707630760 bytes
Literal data: 2707630760 bytes
Matched data: 0 bytes
File list size: 1925417
Total bytes written: 2,711,680,565
Total bytes read: 731844

wrote 2711680565 bytes  read 731844 bytes  8,384,582.41 bytes/sec
total size is 2707740663  speedup is 1.00
Mon Oct 13 07:28:42 EDT 2003


----------------



Jayshankar Nair wrote:

>Hello,
>
>
>I was testing the raid0 configuration for the iscsi device ( /dev/sdb and 
>/dev/sdc).
>
>For writing a 512MB in a LAN environment it was taking 24 hrs. i was going
>through the source code of raid0.c and certain things doesn't made sense to me.
>
>1> what role does the Hash bit play.
>2>If my chunk size is 8 byte. Does that mean it will write 8 byte into device 0 
>and then into device 1. Is the write request to the disk in synchronous or
>asynchronous mode. 
>
>
>3> Is wite_disk_sb in md.c responsible for writing into disk??. Is fsync_dev 
>responsible for synhronous write ??. If so can i change to asynchronous write.I 
>will really appreciate if somebody can tell me what all routines I need to go 
>through to figure out the functionality of raid0 behaviour.
>
>Thanks
>Jayshankar
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

