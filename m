From: "Timothy E. Denehy" <tedenehy@cs.wisc.edu>
Subject: Journal-guided Resynchronization for Software RAID
Date: Wed, 30 Nov 2005 11:15:46 -0600 (CST)
Message-ID: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <ext2-devel-admin@lists.sourceforge.net>
Sender: ext2-devel-admin@lists.sourceforge.net
Errors-To: ext2-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:ext2-devel@lists.sourceforge.net>
List-Help: <mailto:ext2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ext2-devel>
To: linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net
Cc: neilb@cse.unsw.edu.au, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids


I will be presenting a paper at the upcoming USENIX FAST conference
about using the ext3 file system journal to guide the software RAID
resynchronization process.  I was wondering if you had any opinions
as to the viability of this approach in Linux.

Here is a link to the paper:

    http://www.cs.wisc.edu/adsl/Publications/fast05-journal-guided.pdf

and the abstract:

    We investigate the problem of slow, scan-based, software RAID
    resynchronization that restores consistency after a system crash.
    Instead of augmenting the RAID layer to quicken the process, we
    leverage the functionality present in a journaling file system.  We
    analyze Linux ext3 and introduce a new mode of operation, declared
    mode, that guarantees to provide a record of all outstanding writes
    in case of a crash. To utilize this information, we augment the
    software RAID interface with a verify read request, which repairs
    the redundant information for a block. The combination of these
    features allows us to provide fast, journal-guided resynchronization.
    We evaluate the effect of journal-guided resynchronization and find
    that it provides improved software RAID reliability and availability
    after a crash, while suffering little performance loss during normal
    operation.

Thanks,

Tim Denehy



-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
