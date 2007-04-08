From: "Aaron C. de Bruyn" <aaron@darkpixel.com>
Subject: Moron Destroyed RAID6 Array Superblocks
Date: Sat, 07 Apr 2007 21:10:06 -0700
Message-ID: <46186B1E.4010500@darkpixel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok--I'm a moron.
Long story short, I was messing around with my RAID6 array and I managed
to screw up two of the drives in my 7-drive 1-spare array.
I had problems in the middle of a kernel upgrade and I kept getting
errors about various drives having bad superblocks.

So without knowing much about what I was doing, I did a
--zero-superblock on all the drives in the array.
So now I can't reassemble the array.

After reading through the linux-raid archives I have been lead to
believe that I can recover my array by doing a --create and listing the
7 drives in the exact order I originally created them in.  Is this correct?

If so, the kernel upgrade managed to shuffle the drive names around...is
there any way I can figure out what order they should be in?


-A
