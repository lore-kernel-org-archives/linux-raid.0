From: Phil Turmel <philip@turmel.org>
Subject: Re: single threaded parity calculation ?
Date: Fri, 15 Apr 2011 16:54:39 -0400
Message-ID: <4DA8B08F.20604@turmel.org>
References: <4DA89A18.5010002@mcnair.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA89A18.5010002@mcnair.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: simon@mcnair.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/15/2011 03:18 PM, Simon McNair wrote:
> Hi all,

> I'm under the impression that the read speed of my 10x1TB RAID5 array
> is limited by the 'single-threaded parity calculation' ? (I'm quoting
> Phil Turmel on that and other linux-raid messages I've read seem to
> confirm that terminology)  I'm running an i7 920 with irqbalance but
> if something is single threaded or single CPU bound I'm wondering
> what I can do to alleviate it.

I'm not intimately familiar with the code, but I would've thought the single-threaded limitation wouldn't apply to reading from a clean array.

> iostat reports 83MB/s for each disk, running up to 830MB/s for all 10
> disks, but the max read speed of the array is approx 256MB/s.

But this means I'm probably wrong, unless your chunk size is just too small for your setup.  If I recall correctly, it was 64K.  Consider increasing it and retesting to see if it helps.

> Would it be better to have 5 (or more) partitions on each disk,
> create 5xraid5 arrays (each of which would in theory have a separate
> thread) and then create a linear array over the top of them to join
> them together ?

Probably not.  If you use linear on top, any given file is likely to reside in just one of the underlying raids, and will appear to operate at the same speed as you have now.  Streaming multiple files, if they reside in different underlying raids, could go faster computationally, but will suffer from extra seeks just like the plain raid5.

If the 83MB/s is the speed data can be pulled off the platters, a single 8ms seek displaces 664KB of data transfer.

If you put raid0 on top of your underlying raids, you will suffer from excess seeks all the time.

> yes...I know this is way overthinking and also a potentially
> dangerous to recreate, but I'm curious what the opinions are.  I
> think I'll probably just end up buying another 1TB drive and making
> it an 11 disk RAID6 instead.  I want maximum space, maximum speed and
> maximum redundancy ;-).

Heh.  Pick any two.  :-)

Max Space & Speed      == raid0  w/ lots of spindles.
Max Space & Redundancy == raid6  w/ lots of spindles.
Max Speed & Redundancy == raid10 w/ lots of spindles.  

There's a common theme there...

> TIA :-)


Phil
