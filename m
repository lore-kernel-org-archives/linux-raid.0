From: joystick <joystick@shiftmail.org>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 15:49:31 +0100
Message-ID: <52C57C7B.80400@shiftmail.org>
References: <52C1C01A.7010407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C1C01A.7010407@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/12/2013 19:48, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I believe that using a single "chunk size" causes a lose-lose tradeoff
> when creating raid 5/6/10 arrays.

I don't think your analysis is correct.

Firstly you are forgetting that multiple requests are issued 
simultaneously to one disk by the kernel, and they can be served 
out-of-order via NCQ / TCQ by the disks. The kernel does not wait for 
sector N to be read before issuing the read for sector N+1, it issues a 
lot of them together since it knows how much data it has to read (via 
readahead, most of the times). The disk reorders read/write requests 
according to its angular position, so you almost never pay for the 
angular offset during a sequential read/write, not even when skipping 
redundant data from one component disk of the RAID.

Secondly, for writes, I suspect you are assuming that a whole stipe has 
to be read and rewritten in order for one small write to be performed, 
but it is not so. For a 4k write in raid5, two 4k sectors are read, then 
two 4k sectors are written, and this is completely independent from 
chunk size. It already behaves mostly like your "groups", which are the 
stripes actually.


