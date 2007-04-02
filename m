From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: mismatch_cnt worries
Date: Mon, 2 Apr 2007 15:45:09 +0100
Message-ID: <20070402144509.GB21405@gmail.com>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I've relatively recently started using md having had some bad experiences
with hardware raid controllers.  I've had some really good experiences
(stepwise upgrading a 800GB raid5 array to 1.5TB one by exchanging disks
and using mdadm --grow), but am in the middle of a more worrying one.  I have
read previous recent threads about mismatch_cnt and am a little unclear as yet
how to interpret this. I'm seeing this issue on a couple of machines, but I'll
just use talk about one for now.

I ran a check on the three RAID1 arrays in a machine I'm managing.  The check
finished without error.  I then had a look at the mismatch_cnt and one of them
is non-zero (128), specifically the one which holds the root filesystem.

The Gentoo Wiki on the subject seems to be moreorless saying I need to
format the partition to be sure of anything.  Needless to say that's not
desirable.

Stupidly, I have not been running Smart until now but I have installed and
configured it now and run long and short tests manually.  The most interesting
part of the smartctl output on the disks is below but only ECC fast errors are
shown.

All of the event logs look like this, so I guess there's only partial support
for Smart:

  Error event 19:
    :Sense Key  06h Unit Attention  :Add Sense Code 29h :Add Sense Code Qualif  02h :Hardware Status  00h :CCHSS Valid   :CC  ffffh :H No.  00h :SS No. 00

Neil's post here suggests either this is all normal or I'm seriously up the
creek.
	http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07349.html

My questions:

1. Should I be worried or is this normal?  If so can you explain why the
   number is non-zero?
2. Should I repair, fsck, replace a disk, something else?
3. Can someone explain how this quote can be true:
       "Though it is less likely, a regular filesystem could still (I think)
        genuinely write different data to difference devices in a raid1/10."
   when I thought the point of RAID1 was that the data should be the same on
   both disks.

Many thanks for any help/comfort,

Gavin

SDA:
Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:    8878773        0         0   8878773          0        437.620           0
write:         0        0         0         0          0        277.228           0

SDB:
Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:    5077782        0         0   5077782          0        455.871           0
write:         0        0         0         0          0        263.680           0

