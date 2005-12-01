From: Neil Brown <neilb@suse.de>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Thu, 1 Dec 2005 16:19:38 +1100
Message-ID: <17294.34794.477608.760700@cse.unsw.edu.au>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <ext2-devel-admin@lists.sourceforge.net>
In-Reply-To: message from Timothy E. Denehy on Wednesday November 30
Sender: ext2-devel-admin@lists.sourceforge.net
Errors-To: ext2-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:ext2-devel@lists.sourceforge.net>
List-Help: <mailto:ext2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ext2-devel>
To: "Timothy E. Denehy" <tedenehy@cs.wisc.edu>
Cc: linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids

On Wednesday November 30, tedenehy@cs.wisc.edu wrote:
> 
> I will be presenting a paper at the upcoming USENIX FAST conference
> about using the ext3 file system journal to guide the software RAID
> resynchronization process.  I was wondering if you had any opinions
> as to the viability of this approach in Linux.
> 
> Here is a link to the paper:
> 
>     http://www.cs.wisc.edu/adsl/Publications/fast05-journal-guided.pdf
> 

Firstly, a couple of minor points:
   'multimillion dollar price tag' -- maybe a little bit of an
    exaggeration.

    bitmap intent logging for raid1 is now in the mainline kernel (2.6.14)
    and will be for raid4/5/6/10 in 2.6.16. (Your paper says it isn't
    yet, but gives no date or release to give context to your
    statement).


It would be really great if you could do your same tests with
bitmap-based intent logging and see how much is slows writes down.  I
suspect it would be more than with your declared mode, but definite
figures would be great.  (Your comparison on code size is certainly
interesting!).

I agree that closer communication between the filesystem and the
storage system is import to improve raid performance and reliability.
Your 'verified read' sounds like a very appropriate part of that.
There is an awkwardness when a raid array is partitioned as then you
might want the raid system to resync some parts, but leave the
filesystem to resync other parts (And a partition used for swap would
never need syncing at all).  Maybe some very course variety of the
bitmap intent log might be useful here (ext3 with declared mode would
tell raid never to set intent bits..).


Adding full journalling to md is something I have considered from time
to time.  It would need NVRAM to be accepted, and at a couple of
thousand for such a board, it isn't common enough for me to justify
the effort....
What I would really like is a cheap (Well, not too expensive) board
that had at least 100Meg of NVRAM which was addressable on the PCI
buss, and an XOR and RAID-6 engine connected to the DMA engine.  Then
we could use the NVRAM as a write-behind cache and offload all the
parity calculation to it, while still having all the flexibility of
software raid...

I'd probably be happy to consider the 'verified read' enhancements to
md for inclusion in mainline.

Good work!

NeilBrown


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
