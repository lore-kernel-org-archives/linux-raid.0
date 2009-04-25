From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 25 Apr 2009 02:24:59 -0500
Message-ID: <20090425072502456.OPES2063@cdptpa-omta04.mail.rr.com>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> selected probably a 1.2 superblock, instead.  Given all that, unless
> someone
> else has a better idea, I am going to go ahead and tear down the array and
> rebuild it with a version 1.2 superblock.  I have suspended all writes to
> the array and double-backed up all the most critical data along with a
> small
> handful of files which for some unknown reason appear to differ by a few
> bytes between the RAID array copy and the backup copy.  I just hope like
> all
> get-out the backup system doesn't crash sometime in the four days after I
> tear down the RAID array and start to rebuild it.
> 
> I've done some reading, and it's been suggested a 128K chunk size might be
> a
> better choice on my system than the default chunk size of 64K, so I intend
> to create the new array on the raw devices with the command:
> 
> mdadm --create --raid-devices=10 --metadata=1.2 --chunk=128 --level=6
> /dev/sd[a-j]

No one noticed this was missing the target array.  I didn't either until I
ran it and mdadm complained there weren't enough member disks.  'Puzzled the
dickens out of me until I realized mdadm was trying to create an array at
/dev/sda from disks /dev/sdb - /dev/sdj.  'Silly computer.  :-)

For anyone who is interested, the array has been created and formatted, and
the file transfers from the backup have begun, plus I have started to write
all the data I suspended from transferring over the last day or so.  The
system is also resyncing the drives, of course, so there is a persistent
stream of fairly high bandwidth reads going on in addition to the writes.
See below.  So far, nearly 10,000 files have been created without a halt,
and during a RAID resync the system previous would halt with every single
file creation.  Forty-two GB out of over 6T of data has been transferred,
and the system is starting on the large video files right now.  I have high
hopes the problem may have been resolved.  If so, it is almost certain
reiserfs was the culprit, as nothing else has changed except for the
Superblock format and the disk order within the array.  'Fingers crossed.

RAID-Server:/# iostat 1 2
Linux 2.6.26-1-amd64 (RAID-Server)      04/25/2009      _x86_64_

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.62    0.00    6.58   11.04    0.00   78.77

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda              41.00      3440.04      2467.32   19477424   13969924
sdb              41.19      3441.68      2525.79   19486704   14300948
sdc              41.71      3437.65      2533.14   19463912   14342596
sdd              41.62      3445.47      2524.65   19508192   14294540
sde              41.43      3440.61      2467.74   19480680   13972308
sdf              41.24      3441.43      2519.61   19485296   14265996
sdg              41.53      3432.60      2477.87   19435296   14029668
sdh              41.23      3440.57      2528.07   19480416   14313860
sdi              45.09      3443.20      2466.24   19495336   13963796
sdj              45.29      3431.99      2535.49   19431880   14355876
hda               8.56       105.58        89.97     597815     509384
hda1              0.02         0.45         0.00       2540          0
hda2              8.53       104.94        89.92     594160     509104
hda3              0.00         0.00         0.00          6          0
hda5              0.01         0.12         0.05        693        280
md0             103.20         6.34     14438.02      35880   81747792

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11.17    0.00   15.53   35.92    0.00   37.38

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda              55.00      3128.00      4872.00       3128       4872
sdb              50.00      2808.00      4256.00       2808       4256
sdc              44.00      2472.00      3664.00       2472       3664
sdd              42.00      2872.00      3920.00       2872       3920
sde              55.00      2280.00      5360.00       2280       5360
sdf              68.00      2128.00      6984.00       2128       6984
sdg              56.00      2808.00      5432.00       2808       5432
sdh              48.00      3072.00      4608.00       3072       4608
sdi              54.00      3456.00      5008.00       3456       5008
sdj              59.00      3584.00      5008.00       3584       5008
hda              23.00         0.00       184.00          0        184
hda1              0.00         0.00         0.00          0          0
hda2             23.00         0.00       184.00          0        184
hda3              0.00         0.00         0.00          0          0
hda5              0.00         0.00         0.00          0          0
md0             307.00         0.00     33936.00          0      33936
 

