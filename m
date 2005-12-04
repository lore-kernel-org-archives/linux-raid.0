From: Neil Brown <neilb@suse.de>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Mon, 5 Dec 2005 09:40:18 +1100
Message-ID: <17299.28754.5370.230602@cse.unsw.edu.au>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
	<17294.34794.477608.760700@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <ext2-devel-admin@lists.sourceforge.net>
In-Reply-To: message from Neil Brown on Thursday December 1
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

On Thursday December 1, neilb@suse.de wrote:
> 
> I'd probably be happy to consider the 'verified read' enhancements to
> md for inclusion in mainline.

A couple more thoughts on this:

1/ What do you do for a 'verified read' when the array is degraded. 
  For raid1, you can just check whichever devices are working,  but
  for raid5 you really need to report a read error!  

2/ Quoting from the end of section 4.3

] 
]    Finally, an option is added to the software RAID-5
] layer to disable resynchronization after a crash. This
] is our most signicant modication to the strict layering
] of the storage stack. The RAID module is asked to en-
] trust its functionality to another component for the over-
] all good of the system. Instead, an apprehensive software
] RAID implementation may delay its own efforts in hopes
] of receiving the necessary verify read requests from the
] file system above. If no such requests arrive, it could
] start its own resynchronization to ensure the integrity of
] its data and parity blocks.
] 

I agree that this modification doesn't feel ideal. 
An alternate approach would be to have a 'verifiable write' (or some
other more apt name).  The meaning is that the write request says
essentially "don't mark the array as 'dirty' just because of this
request".  The implication is that the after a crash, the fs will do
any 'verified reads' that are required.

If write-intent logging were in use, 'verifiable writes' wouldn't get
recorded in the log and so wouldn't get resynced.  If two different
filesystems were sharing the array (via partitioning) then the part
which got only verifiable writes would not be resynced, but the part
which got normal writes would be.
(If write-intent logging weren't in use, then it will still be an
all-or-nothing situation).

Maybe swap could then use 'verifiable writes' so that the swap
partition would never need to be resynced.

NeilBrown


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
