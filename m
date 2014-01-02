From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 12:02:18 -0600
Message-ID: <52C5A9AA.9090300@hardwarefreak.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C59468.6080200@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/2/2014 10:31 AM, Phillip Susi wrote:
> On 1/2/2014 10:41 AM, Stan Hoeppner wrote:
>> First, there is no such thing as a 4K sector in Linux.  Sectors are
>> 512 bytes.  Filesystem blocks and memory pages are 4K.
> 
> Of course there is.  Disks with 4k sectors are becoming more and more
> popular.  

Please read:  https://en.wikipedia.org/wiki/Advanced_Format

There are no native 4K sector drives on the market.  Linux does not
support a native 4K sector size, only 512 bytes, unless this has changed
in recent kernels and I'm simply not aware of it yet.

> CD-ROM type drives have always used 2k sectors.  Also

This is not relevant to this discussion.

> filesystem blocks and memory pages aren't necessarily 4K, though that
> is the most common size.

Yes, they are necessarily 4K in Linux.  Linux only supports page sized
BIO for consistency across the memory manager and IO subsystems.  Most
architectures which Linux currently supports have hardware page sizes
greater than 4K, for instance IA64 supports 4k/8k/16k, even a 4GB page
size.  But it was decided long ago to stick with 4K for a number of
reasons, one of these is stated above.  For background on this Google is
your friend.

>> read the data chunk of the stripe in which the 4 sectors of the
>> 4KB
> 
> You mean 8 sectors, assuming you're still talking about 512 byte sectors.

Yes, 8 sectors, thanks for catching my brain to finger err.  The ONLY
thing to talk about is 512 byte sectors because this is the only sector
size Linux supports.

-- 
Stan

