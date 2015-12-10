From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 14:28:01 -0500
Message-ID: <22121.53825.857640.201383@quad.stoffel.home>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<22121.38606.101474.41382@quad.stoffel.home>
	<CAE9DZUTO-Muvgp+ofAkoKD1KcunnZ821UeSJch4216iWYL61cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUTO-Muvgp+ofAkoKD1KcunnZ821UeSJch4216iWYL61cQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:

Dallas> On Thu, Dec 10, 2015 at 9:14 AM, John Stoffel <john@stoffel.org> wrote:
>>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>> 
Dallas> Hi all.  I'm trying to determine best and worst case expected
Dallas> sequential write speeds for Linux software RAID with spinning disks.
>> 
Dallas> I have been assuming on the following:
>> 
Dallas> Best case RAID 6 sequential write speed is (N-2) * X, where is is
Dallas> number of drives and X is write speed of a single drive.
>> 
Dallas> Worst case RAID 6 sequential write speed is (N-2) * X / 2.
>> 
Dallas> Best case RAID 5 sequential write speed is (N-1) * X.
>> 
Dallas> Worst case RAID 5 sequential write speed is (N-1) * X / 2.
>> 
Dallas> Could someone please confirm whether these formulas are accurate or not?
>> 
>> 
Dallas> I am not even getting worst case write performance with an
Dallas> array of 12 spinning 7200 RPM SATA disks.  Thus I suspect
Dallas> either the formulas I am using are wrong or I have alignment
Dallas> issues or something.  My chunk size is 128 KB at the moment.
>> 
>> I think you're over-estimating the speed of your disks.  Remember that
>> disk speeds are faster on the outer tracks of the drive, and slower on
>> the inner tracks.
>> 
>> I'd setup two partitions, one at the start and one at the outside and
>> do some simple:
>> 
>> dd if=/dev/zero of=/dev/inner,outer bs=8192 count=100000 oflag=direct
>> 
>> and look at those numbers.  Then build up a table where you vary the
>> bs= from 512 to N, which could be whatever you want.
>> 
>> That will give you a better estimate of individual drive performance.
>> 
>> Then when you do your fio tests, vary the queue depth, block size,
>> inner/outer partition, etc, but all on a single disk at first to
>> compare with the first set of results and to see how they correlate.
>> 
>> THEN you can start looking at the RAID performance numbers.
>> 
>> And of course, the controller you use matters, how it's configured,
>> how it's setup for caching, etc.  Lots and lots and lots of details to
>> be tracked.
>> 
>> Change one thing at a time, then re-run your tests.  Automating them
>> is key here.
>> 
>> 

Dallas> Hi John.  Thanks for the help.  I did what you recommended and created
Dallas> two equal size partitions on my Hitachi 4TB 7200RPM SATA disks.

Dallas> Device          Start        End    Sectors  Size Type
Dallas> /dev/sda1        2048 3907014656 3907012609  1.8T Linux filesystem
Dallas> /dev/sda2  3907016704 7814037134 3907020431  1.8T Linux filesystem

I would do it even differently, put a 10g partition at each end and
run your tests.  

Dallas> I ran the dd test with varying block size.  I started to see a
Dallas> difference in write speed with larger block size.

You will... that's the streaming write speed.  But in real life,
unless you're streaming video or other large large files, you're never
doing to see that. 

Dallas> [root@localhost ~]# dd if=/dev/zero of=/dev/sda1 bs=2048k count=1000
Dallas> oflag=direct
Dallas> 1000+0 records in
Dallas> 1000+0 records out
Dallas> 2097152000 bytes (2.1 GB) copied, 11.5475 s, 182 MB/s

Dallas> [root@localhost ~]# dd if=/dev/zero of=/dev/sda2 bs=2048k count=1000
Dallas> oflag=direct
Dallas> 1000+0 records in
Dallas> 1000+0 records out
Dallas> 2097152000 bytes (2.1 GB) copied, 13.6355 s, 154 MB/s

It will be an even higher difference if you move the partitions to the
ends even more.

Dallas> The difference is not as great as I suspected it might be.  If
Dallas> I plug in this lower write speed of 154 MB/s in the RAID 6
Dallas> worst case write speed calculation mentioned earlier, I should
Dallas> be getting at least (12 - 2) * 154 MB/s / 2 = 770 MB/s.  For
Dallas> this same bs=2048k and queue_depth=256 I am getting 678 MB/s
Dallas> which is almost 100 MB/s less than worst case.

At this point, you need to now look at your controllers and
motherboard and how they're configured.  If all those drives are on
one controller, and if that controller is on a single lane of PCIe,
then you will see controller bandwidth issues as well.

So now you need to step back and look at the entire system.  How is
the drive cabled?  What is the system powered with?

Also, Linux RAID only recently, in recent linux kernels, got away from
single threaded RAID56 compute threads, so that could be an impact
too.

The best way would be to have your disks spread out across multiple
controllers, on multiple busses, all talking in parallel.

If you're looking for a more linear speedup test, build a small 10g
partition on each disk, then build a RAID0 linear stripped array, but
with the small stride number.  Then you do your sequential write and
you should see a pretty linear increase in speed, up until you hit
controller, memory, cpu, SATA limits.

Another option, if you're looking for good performance, might be to
look at lvcache, which is what I've just done at home.  I have a pair
of mirrored 4Tb disks, and a pair of mirrored 500Gb SSDs which I used
for boot, /, /var and cache.  So far I'm quite happy with the
performance speedup.  But I also haven't done *any* rigorous testing,
since I'm more concerned about durability first, then speed.

John
