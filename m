From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Thu, 8 Dec 2005 09:20:33 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512080901280.31862@praktifix.dwd.de>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
 <17294.34794.477608.760700@cse.unsw.edu.au> <Pine.LNX.4.63.0512022211460.4248@twinlark.arctic.org>
 <17299.27732.251785.345960@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <ext2-devel-admin@lists.sourceforge.net>
In-Reply-To: <17299.27732.251785.345960@cse.unsw.edu.au>
Sender: ext2-devel-admin@lists.sourceforge.net
Errors-To: ext2-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:ext2-devel@lists.sourceforge.net>
List-Help: <mailto:ext2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ext2-devel>
To: Neil Brown <neilb@suse.de>
Cc: dean gaudet <dean-list-linux-raid@arctic.org>, "Timothy E. Denehy" <tedenehy@cs.wisc.edu>, linux-raid <linux-raid@vger.kernel.org>, ext2-devel@lists.sourceforge.net, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids

On Mon, 5 Dec 2005, Neil Brown wrote:

> On Friday December 2, dean-list-linux-raid@arctic.org wrote:
>> On Thu, 1 Dec 2005, Neil Brown wrote:
>>
>>> What I would really like is a cheap (Well, not too expensive) board
>>> that had at least 100Meg of NVRAM which was addressable on the PCI
>>> buss, and an XOR and RAID-6 engine connected to the DMA engine.
>>
>> there's the mythical giga-byte i-ram ... i say mythical because i've seen
>> lots of reviews but haven't been able to find it for sale:
>>
>> http://www.giga-byte.com/Peripherals/Products/Products_GC-RAMDISK%20(Rev%201.1).htm
>>
>> the only problem with the i-ram is the lack of ecc (it could be
>> implemented in a software layer though).
>
> The lack of ECC is a real killer for any sort of raid/journalling
> application.  You want your journal to be more-resilient to failure
> than your main array, not less.
> And the fact that the board presents like an IDE controller (if I read
> that right) means it is meant as fast-disk.  Not as a generally useful
> board to do interesting things with :-(
>
> The idea of just providing memory slots that you plug your own memory
> into is certainly interesting.  It would mean making just one board
> and the custom could choose how much memory they wanted to buy. (umem
> below may several different sizes).  I wonder if it affects
> reliability at all...
>
>>
>> umem.com have what look like excellent boards but they seem unwilling to
>> sell in small quantities...
>>
>> http://umem.com/Umem_NVRAM_Cards.html
>
I also tried to contact them, so thats why I did not get any reply.

> I have two of these in two different servers... I must have got them
> at a time when small quantities weren't so unpalatable.   They have
> full ECC, and even have a driver in kernel.org kernels (I had to
> convince them that GPL wasn't bad, but that wasn't too hard).
> The boards I got only presented a 64M (I think) window to the PCI
> buss, though I believe they have versions that present to whole of
> memory instead of just one window.
>
Do you have any performance numbers that show how these cards increase
performance? I have tried doing it with a ramdisk and the performance
was not much better, using ext3 and journal on ramdisk. ext2 is still
much faster, here some quick tests with dd:

      2.6.15-rc1-git2

      time dd if=/dev/full of=/home/aaaa bs=4M count=4883
      SW Raid 1+0
      ext2
      real    1m11.856s 1m16.050s 1m18.449s
      user     0m0.020s  0m0.000s  0m0.010s
      sys     0m44.630s 0m44.820s 0m45.870s

      ext3 ordered
      real    2m17.314s 1m51.732s 1m51.258s
      user     0m0.030s  0m0.020s  0m0.010s
      sys     1m41.370s 1m38.300s 1m36.820s

      ext3 writeback
      real    2m1.511s  1m40.958s 1m43.889s
      user    0m0.070s   0m0.000s  0m0.000s
      sys     1m33.390s 1m21.470s 1m23.430s

      ext3 writeback+external journal in ram disk
      real     2m5.357s 1m41.349s 1m36.228s
      user     0m0.010s  0m0.020s  0m0.010s
      sys     1m37.500s 1m24.110s 1m21.960s

Wonder how one can increase the write performance but still having a journal.

Holger



-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
