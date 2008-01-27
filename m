From: "TJ Harrell" <tj@systemloc.com>
Subject: 2 failed disks RAID 5 behavior bug?
Date: Sun, 27 Jan 2008 14:44:09 -0500
Message-ID: <000301c8611c$fdfcf090$f9f6d1b0$@com>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
	<18084.22271.122052.80056@notabene.brown>
	<170fa0d20707230547y3accc5c9v14805fdb3637e9c0@mail.gmail.com>
	<18098.52840.936611.7816@notabene.brown>
	<170fa0d20708030641l258ff0adrfdfa7726f746969e@mail.gmail.com>
 <18099.40761.348959.46664@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <18099.40761.348959.46664@notabene.brown>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: systemloc@verizon.net
List-Id: linux-raid.ids

Hi!

Let me apologize in advance for not having as much information as I'd like
to.

I have a RAID 5 array with 3 elements. Kernel is 2.6.23.

I had a SATA disk fail. On analysis, it's SMART claimed it had an
'electrical failure'. The drive sounded like an angry buzz-saw, so I'm
guessing more was going on with it. Anyway, when the drive failed,
/proc/mdstat showed two drives marked as failed [__U]. The other failed
drive was on the other channel of the same SATA controller. On inspection,
this second drive works fine. I'm guessing somehow the failing drive caused
the SATA controller to lock or something, which caused the RAID layer to
think the second drive was failed.

The problematic behavior is that once two elements were marked as failed,
any read or write access resulted in an "I/O Failure" message.
Unfortunately, I believe some writes were made to the array as the Event
Counter did not match on the two functional elements, and there was quite a
bit of data corruption of the superblock of the FS. 

I'm sorry I don't have more specifics, but I hope perhaps Mr. Brown or
someone else who knows the RAID code will consider making some sort of
safeguard to prevent writing to a RAID 5 array when more than one element is
failed.

PS: Please CC: me. :)

Thank You!
TJ Harrell
systemloc@verizon.net

