From: "Riley Williams" <Riley@Williams.Name>
Subject: RE: MD drivers problems on 2.4.x
Date: Mon, 26 May 2003 09:17:28 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BKEGKPICNAKILKJKMHCAOEFAEBAA.Riley@Williams.Name>
References: <15F26D0D9E18E24583D912511D668FF8017F8C@exchange.ad.tlogica.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15F26D0D9E18E24583D912511D668FF8017F8C@exchange.ad.tlogica.com>
To: Michael Daskalov <MDaskalov@technologica.biz>
Cc: Linux-RAID@vger.kernel.org
List-Id: linux-raid.ids

Hi Michael.

Unfortunately, I'm no RAID expert - I've never been in a position to
use RAID myself. As a result, I'm unable to help with your problem.

I've CC'd this to the Linux-RAID reflector where people who can help
you are likely to be found...

Best wishes from Riley.
---
 * Nothing as pretty as a smile, nothing as ugly as a frown.


 > -----Original Message-----
 > From: Michael Daskalov [mailto:MDaskalov@technologica.biz]
 > Sent: Monday, May 26, 2003 8:39 AM
 > To: Riley Williams
 > Subject: RE: MD drivers problems on 2.4.x
 >
 > Hi,
 >
 > I had similar problem with Kernel 2.4.18 from SuSE.
 > I have 4x120GB IDE disks from IBM/Hitachi.
 >
 > I've setup raid 5 on 4 disk (/dev/hda7, /dev/hdb7, /dev/hdc7,
 > /dev/hdd7). I've also setup raid1 (/dev/hda1, /dev/hdc1) and
 > some other raid1 md devices.
 >
 > The system was running fine for a week but suddenly /dev/hdd
 > gave me an error while reading one single block (on /dev/hdd5).
 >
 > I was trying to read it with  dd if=/dev/hdd7  and it failed
 > every time. I tried to read it with dd if=/dev/hdd and I
 > succeeded.
 >
 > I rebooted the computer with some Hitachi test diskette, and
 > tested the HDD in Full mode.
 >
 > It says there were no errors at all. I am not a S.M.A.R.T.
 > expert but I think if it was really hardware error, it would
 > be reported in SMART's error log.
 >
 > Then I thought, OK - the drive should be fine, I'll just
 > 'raidhotadd' it to the array and everything will be fine.
 > It almost suceeded. While reconstructing the array /dev/had
 > gave a similar error, but it was on another LBA sector.
 >
 > So, my whole raid5 was gone. Luckily it was still in test-only
 > mode.
 >
 > I switched to vanilla 2.4.20 which I self compiled, and it is
 > running fine for now.
 >
 > I just know I shouldn't count on this too much, but do I have
 > an alternative?!?
 >
 > Here are the error from /var/log/messages:
 >
 > May  6 00:15:16 devsrv kernel: hdd: dma_intr: status=0x51 {
 >		DriveReady SeekComplete Error }
 > May  6 00:15:16 devsrv kernel: hdd: dma_intr: error=0x40 {
 >		UncorrectableError }, LBAsect=24145681, high=1,
 >		low=7368465, sector=32048
 > May  6 00:15:16 devsrv kernel: end_request: I/O error, dev 16:47
 >		(hdd), sector 32048
 > May  6 00:15:16 devsrv kernel: raid5: Disk failure on hdd7,
 >		disabling device. Operation continuing on 3 devices
 > May  6 00:15:16 devsrv kernel: md: updating md2 RAID superblock
 >		on device
 > May  6 00:15:16 devsrv kernel: md: (skipping faulty hdd7 )
 >
 > .....
 >
 > May  7 14:42:58 devsrv kernel: hda: dma_intr: error=0x40 {
 >		UncorrectableError }, LBAsect=38454698, high=2,
 >		low=4900266, sector=14341032
 > May  7 14:42:58 devsrv kernel: end_request: I/O error, dev 03:07
 >		(hda), sector 14341032
 > May  7 14:42:58 devsrv kernel: raid5: Disk failure on hda7,
 >		disabling device. Operation continuing on 2 devices
 > May  7 14:42:58 devsrv kernel: md: updating md2 RAID superblock
 >		on device
 > May  7 14:42:58 devsrv kernel: md: hdb7 [events:
 >		00000046]<6>(write) hdb7's sb offset: 30724160
 > May  7 14:42:58 devsrv kernel: md: recovery thread got woken up ...
 > May  7 14:42:58 devsrv kernel: md2: no spare disk to reconstruct
 >		array! -- continuing in degraded mode
 >
 > .... And then
 >
 > May  7 14:42:58 devsrv kernel: md: recovery thread finished ...
 > May  7 14:42:58 devsrv kernel: md: hdc7 [events:
 >		00000046]<6>(write) hdc7's sb offset: 30724160
 > May  7 14:42:58 devsrv kernel: md: (skipping faulty hda7 )
 > May  7 14:43:02 devsrv kernel: vs-13070: reiserfs_read_inode2:
 >		i/o failure occurred trying to find stat data of [144691
 >		148158 0x0 SD]
 > May  7 14:43:02 devsrv kernel: vs-13070: reiserfs_read_inode2:
 >		i/o failure occurred trying to find stat data of [144691
 >		148158 0x0 SD]
 > May  7 14:43:02 devsrv kernel: vs-13070: reiserfs_read_inode2:
 >		i/o failure occurred trying to find stat data of [144691
 >		208720 0x0 SD]
 > May  7 14:43:02 devsrv kernel: vs-13070: reiserfs_read_inode2:
 >		i/o failure occurred trying to find stat data of [144691
 >		208720 0x0 SD]
 >
 > Here is some very ugly bug IMHO. See:
 >
 > May  7 14:42:58 devsrv kernel: raid5: Disk failure on hda7,
 >		disabling device. Operation continuing on 2 devices
 > 
 > How can a raid5 array built on 4 devices to operate with 2 devices ?
 > It should rather stop and do nothing ....
 >
 > The after reboot I did
 > mkraid --dangerous-no-resync --force /dev/md2
 > I was able to mount the reiserfs 3.6 format. I was able to read
 > some data from some files, But it was very heavily corrupted.
 > The Oracle installation that was there was useless (sqlplus gave
 > Segmentation faults), and so on.

---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.483 / Virus Database: 279 - Release Date: 19-May-2003

