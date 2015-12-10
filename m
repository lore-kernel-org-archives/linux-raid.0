From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 10:14:22 -0500
Message-ID: <22121.38606.101474.41382@quad.stoffel.home>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:

Dallas> Hi all.  I'm trying to determine best and worst case expected
Dallas> sequential write speeds for Linux software RAID with spinning disks.

Dallas> I have been assuming on the following:

Dallas> Best case RAID 6 sequential write speed is (N-2) * X, where is is
Dallas> number of drives and X is write speed of a single drive.

Dallas> Worst case RAID 6 sequential write speed is (N-2) * X / 2.

Dallas> Best case RAID 5 sequential write speed is (N-1) * X.

Dallas> Worst case RAID 5 sequential write speed is (N-1) * X / 2.

Dallas> Could someone please confirm whether these formulas are accurate or not?


Dallas> I am not even getting worst case write performance with an
Dallas> array of 12 spinning 7200 RPM SATA disks.  Thus I suspect
Dallas> either the formulas I am using are wrong or I have alignment
Dallas> issues or something.  My chunk size is 128 KB at the moment.

I think you're over-estimating the speed of your disks.  Remember that
disk speeds are faster on the outer tracks of the drive, and slower on
the inner tracks.

I'd setup two partitions, one at the start and one at the outside and
do some simple:

  dd if=/dev/zero of=/dev/inner,outer bs=8192 count=100000 oflag=direct

and look at those numbers.  Then build up a table where you vary the
bs= from 512 to N, which could be whatever you want.

That will give you a better estimate of individual drive performance.

Then when you do your fio tests, vary the queue depth, block size,
inner/outer partition, etc, but all on a single disk at first to
compare with the first set of results and to see how they correlate.

THEN you can start looking at the RAID performance numbers.

And of course, the controller you use matters, how it's configured,
how it's setup for caching, etc.  Lots and lots and lots of details to
be tracked.

Change one thing at a time, then re-run your tests.  Automating them
is key here.


