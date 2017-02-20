From: George Rapp <george.rapp@gmail.com>
Subject: Reshape stalled at first badblock location (was: RAID 5 --assemble
 doesn't recognize all overlays as component devices)
Date: Mon, 20 Feb 2017 17:18:46 -0500
Message-ID: <CAF-KpgY0ySvCN9ftbDmW_P6wDiyfN2yWE6=NECVru4=vCe+pbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

On Sat, Feb 11, 2017 at 7:32 PM, George Rapp <george.rapp@gmail.com> wrote:
> Previous thread: http://marc.info/?l=linux-raid&m=148564798430138&w=2
> -- to summarize, while adding two drives to a RAID 5 array, one of the
> existing RAID 5 component drives failed, causing the reshape progress
> to stall at 77.5%. I removed the previous thread from this message to
> conserve space -- before resolving that situation, another problem has
> arisen.
>
> We have cloned and replaced the failed /dev/sdg with "ddrescue --force
> -r3 -n /dev/sdh /dev/sde c/sdh-sde-recovery.log"; copied in below, or
> viewable via https://app.box.com/v/sdh-sde-recovery . The failing
> device was removed from the server, and the RAID component partition
> on the cloned drive is now /dev/sdg4.

[previous thread snipped - after stepping through the code under gdb,
I realized that "mdadm --assemble --force" was needed.]

# uname -a
Linux localhost 4.3.4-200.fc22.x86_64 #1 SMP Mon Jan 25 13:37:15 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux
# mdadm --version
mdadm - v3.3.4 - 3rd August 2015

As previously mentioned, the device that originally failed was cloned
to a new drive. This copy included the bad blocks list from the md
metadata, because I'm showing 23 bad blocks on the clone target drive,
/dev/sdg4:

# mdadm --examine-badblocks /dev/sdg4
Bad-blocks on /dev/sdg4:
          3802454640 for 512 sectors
          3802455664 for 512 sectors
          3802456176 for 512 sectors
          3802456688 for 512 sectors
          3802457200 for 512 sectors
          3802457712 for 512 sectors
          3802458224 for 512 sectors
          3802458736 for 512 sectors
          3802459248 for 512 sectors
          3802459760 for 512 sectors
          3802460272 for 512 sectors
          3802460784 for 512 sectors
          3802461296 for 512 sectors
          3802461808 for 512 sectors
          3802462320 for 512 sectors
          3802462832 for 512 sectors
          3802463344 for 512 sectors
          3802463856 for 512 sectors
          3802464368 for 512 sectors
          3802464880 for 512 sectors
          3802465392 for 512 sectors
          3802465904 for 512 sectors
          3802466416 for 512 sectors

However, when I run the following command to attempt to read each of
the bad blocks, no I/O errors pop up either on the command line or in
/var/log messages:

# for i in $(mdadm --examine-badblocks /dev/sdg4 | grep "512 sectors"
| cut -c11-20) ; do dd bs=512 if=/dev/sdg4 skip=$i count=512 | wc -c;
done

I've truncated the output, but in each case it is similar to this:

512+0 records in
512+0 records out
262144
262144 bytes (262 kB) copied, 0.636762 s, 412 kB/s

Thus, the bad blocks on the failed hard drive are apparently now
readable on the cloned drive.

When I try to assemble the RAID 5 array, though, the process gets
stuck at the location of the first bad block. The assemble command is:

# mdadm --assemble --force /dev/md4
--backup-file=/home/gwr/2017/2017-01/md4_backup__2017-01-25 /dev/sde4
/dev/sdf4 /dev/sdh4 /dev/sdl4 /dev/sdg4 /dev/sdk4 /dev/sdi4 /dev/sdj4
/dev/sdb4 /dev/sdd4
mdadm: accepting backup with timestamp 1485366772 for array with
timestamp 1487624068
mdadm: /dev/md4 has been started with 9 drives (out of 10).

The md4_raid5 process immediately spikes to 100% CPU utilization, and
the reshape stops at 1901225472 KiB (which is exactly half of the
first bad sector value, 3802454640):

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md4 : active raid5 sde4[0] sdb4[12] sdj4[7] sdi4[8] sdk4[11] sdg4[10]
sdl4[9] sdh4[2] sdf4[1]
      13454923776 blocks super 1.1 level 5, 512k chunk, algorithm 2
[10/9] [UUUUUUUUU_]
      [===================>.]  reshape = 98.9% (1901225472/1922131968)
finish=2780.9min speed=125K/sec

unused devices: <none>

Googling around, I get the impression that resetting the badblocks
list is (a) not supported by the mdadm command; and (b) considered
harmful. However, if the blocks aren't really bad any more, as they
are now readable, does that risk still hold? How can I get this
reshape to proceed?

Updated mdadm --examine output is at
https://app.box.com/v/raid-status-2017-02-20

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
