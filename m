From: "Alex V. Verbitsky" <alexver5@mail.ru>
Subject: poor raid5 performance of 3ware 7500 under Linux
Date: Sat, 14 Jun 2003 00:15:59 +0300
Sender: ataraid-list-admin@redhat.com
Message-ID: <5038410962.20030614001559@mail.ru>
Reply-To: ataraid-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: 8bit
Return-path: <ataraid-list-admin@redhat.com>
Errors-To: ataraid-list-admin@redhat.com
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Post: <mailto:ataraid-list@redhat.com>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list/>
To: ataraid-list@redhat.com
Cc: linux@3ware.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi people,

I am experiencing a poor sequental write performance with 3-disk RAID5
array on 3Ware 7500-8 - it is only 11-12 MB/s. Under Win2000 i get 30-35 MB/s
from the same array.

I have used different methods: dd, iometer and "copy /dev/zero tstfile"
- they all give me the same low figures (11-12 MB/s).

Has anybody managed to get good (> 30 MB/s) raid 5 write performance
from 3ware 7500 on Linux and desktop (non-server) hardware - 32-bit
33MHz PCI ?
And why does Linux give much worse performance than Win2k?
It was disapointing for me to see this after i recommended 3ware cards for
our NAS solution.

3ware use server motherboards and Windows 2k and for their benchmarks.
I found several Linux benchmarks that showed good results but they used server motherboards:
http://home.fnal.gov/~yocum/storageServerTechnicalNote.html
http://pcbunn.cacr.caltech.edu/gae/3ware_raid_tests.htm

I also found that another Russian guy had the same problem a year ago:
http://bioinformatics.org/pipermail/bioclusters/2002-August/000364.html

I run RedHat 9 with unchanged kernel and have updated firmware and
drivers to 7.6 version 3Ware software. Write cache is enabled.
Disks used are 80 GB ibm 120gxp (IC35L080AVVA07-0).

I used 2 hardware configurations:
1) Via Epia-M motherboard with C3-933 Mhz, 256MB RAM
2) Asus A7V133 with Athlon 1Ghz, 512 MB RAM
- they showed the same results except for CPU utilization:
on Epia i get high numbers (50-70% for read, 90-100% for write) and
on Athlon numbers are much lower(22-36% read, 7% for write).

I also tested RAID0 3-disk array on Epia (just trying to understand what's
wrong - i need RAID5 for my solution) and get the strange results:
iometer:
   seq. read (64-1024KB blocks,  1-64 outst. I/O) - 34 ÌB/s, CPU total 65-70%
   seq. write (64-1024KB blocks,  1-64 outst. I/O) - 48 ÌB/s, CPU total 100%
file copy (ext2 file system)
   seq. read (cp testfile /dev/null) - 54 ÌB/s, CPU total 45 %
   seq. write (cp /dev/zero testfile) - 60 ÌB/s, CPU total 93 %
hdparm
      [root@RH9 3w]# hdparm -tT /dev/sda
      /dev/sda:
        Timing buffer-cache reads:   128 MB in  1.94 seconds = 65.98 MB/sec
        Timing buffered disk reads:  64 MB in  2.00 seconds = 32.00 MB/sec

Under Win2k i get from this array 100 MB/s (66 MB/s at disk end) read and 61 MB/s
write with much lower CPU usage.
   


Thanks in advance for any help,
sorry for my poor English.

-- 
Best regards,
 Alex                          mailto:alexver5@mail.ru
