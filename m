From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:07:27 +0300
Message-ID: <479F331F.7080902@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F0AAB.3090702@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Moshe Yudkowsky wrote:
>>
>> One of the puzzling things about this is that I conceive of RAID10 as
>> two RAID1 pairs, with RAID0 on top of to join them into a large drive.
>> However, when I use --level=10  to create my md drive, I cannot find
>> out which two pairs are the RAID1's: the --detail doesn't give that
>> information. Re-reading the md(4) man page, I think I'm badly mistaken
>> about RAID10.
>>
>> Furthermore, since grub cannot find the /boot on the md drive, I
>> deduce that RAID10 isn't what the 'net descriptions say it is.

In fact, everything matches.  For lilo to work, it basically needs
a whole filesystem on the same physical drive.  It's exactly the case
with raid1 (and only).  With raid10, half of the filesystem is on one
mirror, and another half is on another mirror.  Like this:

 filesystem          blocks on raid0
 blocks              DiskA    DiskB

  0                  0
  1                           1
  2                  2
  3                           3
  4                  4
  5                           5
  ..

(this is          (this is the actual
what LILO          layout)
expects)

(Difference between raid10 and raid0 is that
each of diskA and diskB is in fact composed of
two identical devices).

If your kernel is located in filesytem blocks
number 2 and 3 for example, lilo has to read
BOTH halves, but it is not smart enough to
figure it out - it can only read everything
from a single drive.

> It is exactly what the names implies - a new kind of RAID :) The setup
> you describe is not RAID10 it is RAID1+0.

Raid10 IS RAID1+0 ;)
It's just that linux raid10 driver can utilize more.. interesting ways
to lay out the data.

/mjt
