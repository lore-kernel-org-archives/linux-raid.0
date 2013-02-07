From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 23:37:02 +1100
Message-ID: <51139FEE.3020807@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <51139799.2070004@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030809040304080506080305"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51139799.2070004@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030809040304080506080305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/02/13 23:01, Brad Campbell wrote:
> On 07/02/13 18:19, Adam Goryachev wrote:
> 
>> problem. Is there some way to instruct the disk (overnight) to TRIM the
>> extra blank space, and do whatever it needs to tidy things up? Perhaps
>> this would help, at least first thing in the morning if it isn't enough
>> to get through the day. Potentially I could add a 6th SSD, reduce the
>> partition size across all of them, just so there is more blank space to
>> get through a full day worth of writes?
> 
> I have 6 SSD's in a RAID10, and with 3.7.x (I forget which x - 2 or 3
> from memory) md will pass the TRIM down to the underlying devices (at
> least for RAID10 and from memory 1).

Yes, I have read that the very new kernel has those patches, but I'm on
2.6.x at the moment, and in addition, see below why they wouldn't help
anyway...

> I have a cronjob that runs at midnight :
> Based on the run times, and the bytes trimmed count I suspect it works.
> All filesystems are ext4. Two of them are passed through encryption, but
> that passes TRIM down also. I do not have the discard option on any
> mounts (that way lies severe performance issues).

I don't have any FS on this RAID, it is like this:
5 x SSD
RAID5 (doesn't support TRIM, though I've seen some patches but I think
they are not included in any kernel yet).
DRBD (doubt this supports TRIM
LVM (don't think it supports TRIM, maybe in newer kernel)
iSCSI (don't think it support TRIM
Windows 2003 and Windows 2000 (don't think it supports TRIM)

So, really, all I want to do is use TRIM on the portion of the drive
which is not partitioned at all, and I suspect the SSD knows that
section is available, but how do I tell the drive "please go and do a
cleanup now, because the users are all sleeping"?

BTW, I just created a small LV (15G) and ran a couple of write tests
(well, not proper one, but at least you get some idea how bad things are).
dd if=/dev/zero of=/dev/vg0/testlv oflag=direct bs=16k count=50k
^C50695+0 records in
50695+0 records out
830586880 bytes (831 MB) copied, 99.4635 s, 8.4 MB/s

I killed it after waiting a while....  this is while most of the systems
are idle, except one which is currently being backed up (lots of reads,
small number of writes). This is indicative of IO starvation though, I
would have expected a significantly higher write performance?

While I was running the dd, I ran a iostat -x 5 in another session:

See text file attached for output, as seems to want to line wrap because
it is too wide....

dm-13 is the client (windows 2003) which is currently being backed up,
dm-14 is the testlv I'm writing to from the localhost.

Suggestions on better testing methods or is this expected?

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

--------------030809040304080506080305
Content-Type: text/plain; charset=UTF-8;
 name="stats.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stats.txt"

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.20     0.00     1.60     8.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00  500.80  881.00  4648.20  7029.00     8.45     0.12    0.09   0.03   3.76
sdc               0.00     0.00  509.60  895.20  4676.20  7142.60     8.41     0.11    0.08   0.03   4.08
sdd               0.00     0.00  520.00  900.60  4753.80  7185.80     8.40     0.11    0.07   0.03   4.00
sde               0.00     0.00  528.80  922.80  4831.20  7363.40     8.40     0.16    0.11   0.04   5.20
sdf               0.60     0.00  515.00  906.60  4744.00  7233.80     8.43     0.14    0.10   0.04   5.04
md1               0.00     0.00  200.60  601.40  4659.80 17917.60    28.15     0.00    0.00   0.00   0.00
drbd2             0.00     0.00  200.60  599.80  4659.80 17916.00    28.21     1.15    1.45   1.25  99.84
dm-1              0.00     0.00   29.00    4.60   464.00    67.40    15.82     0.01    0.26   0.21   0.72
dm-5              0.00     0.00    0.20    2.80     1.60    13.40     5.00     0.01    2.40   1.60   0.48
dm-13             0.00     0.00  170.20   67.40  4184.60  1129.60    22.37     0.14    0.58   0.38   8.96
dm-21             0.00     0.00    0.00    0.60     0.00     8.00    13.33     0.00    0.00   0.00   0.00
dm-29             0.00     0.00    0.20    0.80     1.60     9.60    11.20     0.00    0.80   0.80   0.08
dm-37             0.00     0.00    0.20    0.00     1.60     0.00     8.00     0.00    0.00   0.00   0.00
dm-45             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-53             0.00     0.00    0.00    1.20     0.00     9.60     8.00     0.00    1.33   0.67   0.08
dm-61             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-65             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-71             0.00     0.00    0.20    0.80     1.60    11.20    12.80     0.00    1.60   1.60   0.16
dm-9              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-15             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.40    1.20     3.20     9.60     8.00     0.00    0.00   0.00   0.00
dm-11             0.00     0.00    0.40    2.80     3.20    13.40     5.19     0.01    2.00   1.25   0.40
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-3              0.00     0.00    0.00    0.60     0.00     4.80     8.00     0.00    2.67   1.33   0.08
dm-4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-10             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00    0.00    0.40     0.00     3.20     8.00     0.00    2.00   2.00   0.08
dm-14             0.00     0.00    0.00  520.60     0.00 16659.20    32.00     1.00    1.92   1.92 100.00


--------------030809040304080506080305--
