From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Dual disk RAID 5 failure!
Date: Tue, 30 Nov 2004 13:33:27 +1100
Message-ID: <16811.56311.863221.129431@cse.unsw.edu.au>
References: <A6264114-3F0D-11D9-8034-000A959A30DC@postbox.org.uk>
	<41A63328.40907@dgreaves.com>
	<C40728DE-3F1F-11D9-8034-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-admin@lists.sourceforge.net>
In-Reply-To: message from Chris Birkinshaw on Thursday November 25
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: Chris Birkinshaw <chris@postbox.org.uk>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org, evms-devel@lists.sourceforge.net
List-Id: linux-raid.ids

On Thursday November 25, chris@postbox.org.uk wrote:
> >> Hi,
> >>
> >> Last night one of my drives got corrupted during a crash, but also 
> >> corrupted the other drive on that controller (I know I should only 
> >> have one drive per controller but you know how it is.... stable door 
> >> and all that).
> >>
> >> So I now have 2 disks missing from my RAID 5 with corrupt 
> >> superblocks. Is there any way to get back from this, there was around 
> >> 400Gb of data on there....
> >>
> >> If anyone has any idea at all that may help I would be very happy to 
> >> hear it,

Have you tried:
   mdadm --assemble --force /dev/mdWHATEVER /dev/list-of-devices-that-contain-the-array

??

NeilBrown


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
