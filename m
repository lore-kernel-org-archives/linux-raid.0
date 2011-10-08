From: Gordon Henderson <gordon@drogon.net>
Subject: Re: How to stress test an RAID 6 array?
Date: Sat, 8 Oct 2011 15:44:12 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1110081516550.9066@unicorn.drogon.net>
References: <4E89B81D.5000800@yazzy.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89B81D.5000800@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 3 Oct 2011, Marcin M. Jessa wrote:

> Now I would like to stress test the array and see whether it would fail again 
> or not. What would be the best way to do that?

Once upon a time I used to write test & diagnostic software for some 
custom designed (and rather big at the time) systems... One of the early 
things I learned was that no-matter what tests I thought of, some end-user 
would find some code that triggered some weird border-case that the test 
software would fail to find, so ... It's going to vary, depending on 
exactly what you're trying to test...

However, a soak-test I apply to all my servers goes as follows:

1. create a file of 2 x RAM size:

   dd if=/dev/urandom of=testfile00 bs=1M count=8192 # 8GB file, 4GB RAM

2. copy this file to another file and copy that to another, etc.

   cp -a testfile00 testfile01
   cp -a testfile01 testfile02

and so on. (obivously in a loop) Do this until the disk is full. (Use a 
file double RAM size to hopefully eliminate the effects of any Linux 
FS/block cache/buffering)

Compare md5checksums of testfile00 and testfileXX.

Using non blocking IO (dd with i/o flag=nonblock) might put more stress on 
the system by trying to overlap reads and writes, but I've not checked.

My aim here is to see if there have been any bit-errors during the disk 
fill operation - however it won't tell me where the error happened, nor 
what caused the error - memory, pci bus, sata cable, or something 
undetected by the disk. With multi-disk arrays, hopefully it'll be writing 
over all drives at once, but only reading from the active (non 
parity/mirror) drives.

(Is there some MD options that might force it to read all the drives all 
the time and do the parity check while in 'normal' use? Sure it might slow 
it down, but for soaktesting, it might be handy...)

I used to test memory like this way back in some old processors that had a 
block-move instruction - it ran the address/data bus as fast as it could 
which was a good test - my thoughts are that it's hopefully doing someting 
similar here... You could treat it like memory and put different patterns 
in the first block - all zeros, all ones, alternating ones and zeros, etc. 
depending on how you think the transfers are worst over the various buses 
- e.g. alternating 1010 might be bad on a serial bus, but will present the 
same patterns over a parallel bus, so if the bus is 8-bits wide, then 
alternating 0xFF, 0x00 (or (0xAA, 0x55) might be better - who knows.

I do know it takes a long time on todays very big disks )-:

My full soak test involves doing a Linux kernel compile at the same time 
as doing the above (in a loop - make -jX bzImage ; make clean ; repeat - X 
= numCpus), and doing some large FTPs to & from the box to make the 
network hardware work at the same time.

You can always throw in a burnMMX or burnBX at the same time for good 
measure...

Gordon
