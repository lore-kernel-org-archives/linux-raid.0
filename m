From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 09:41:27 -0600
Message-ID: <52C588A7.6010207@hardwarefreak.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C57C7B.80400@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>, Phillip Susi <psusi@ubuntu.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/2/2014 8:49 AM, joystick wrote:
> For a 4k write in raid5, two 4k sectors are read, then
> two 4k sectors are written, and this is completely independent from
> chunk size.

First, there is no such thing as a 4K sector in Linux.  Sectors are 512
bytes.  Filesystem blocks and memory pages are 4K.

I'm no expert WRT raid5.c/raid6.c, but I'm pretty sure it doesn't work
as you state.  I'm pretty sure it works like this:

Redundancy is maintained at the chunk level, not the filesystem block
level or page level.  If modifying a single filesystem block, md will
read the data chunk of the stripe in which the 4 sectors of the 4KB
block resides, write back the chunk incorporating the changes to the 4
sectors, read the parity chunk, recalculate the parity chunk based on
the new data chunk, and then write back the parity chunk.

This is precisely why many folks, including myself, consider the current
512KB chunk default to be way too high.  Modifying a single 4KB
filesystem block requires reading 1MB from disk and writing 1MB, a total
of 2MB of IO just to modify a single 4KB page.  And AFAIK this is the
best case scenario.  According to past posts by Neil, IIRC, the current
RAID5/6 code may read more than just two chunks during RMW depending on
certain factors.  With RAID6 you have at least one extra chunk write, if
not an extra chunk read, so your IO is at least 2.5MB for a single 4K
write with RAID6.

-- 
Stan


