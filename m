From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID1 and data safety?
Date: Mon, 04 Apr 2005 16:06:06 -0400
Message-ID: <1112645166.29559.37.camel@compaq-rhel4.xsintricity.com>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
	 <16969.10547.894461.398225@cse.unsw.edu.au>
	 <ipqnh2-o1n.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ipqnh2-o1n.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-03-29 at 13:29 +0200, Peter T. Breuer wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > Due to the system crash the data on hdb is completely ignored.  Data
> 
> Neil - can you explain the algorithm that stamps the superblocks with
> an event count, once and for all? (until further amendment :-).

I think the best explanation is this:  any change in array state that
would necessitate kicking a drive out of the array if it didn't also
make this change in state with the rest of the drives in the array
results in an increment to the event counter and a flush of the
superblocks.  For example, a transition of a raid array from ro to rw
mode results in an event update and a flush of superblocks.  If the
system then goes down and one drive has the superblock update and
another doesn't, then you know that one was behind the other and to kick
it.

> It goes without saying that sb's are not stamped at every write, and the
> event count is not incremented at every write, so when and when?

Transition from ro -> rw or from rw -> ro, transition from clean to
dirty or dirty to clean, any change in the distribution of disks in the
superblock (aka, change in number of working disks, active disks, spare
disks, failed disks, etc.), or any ordering updates of disk devices in
the rdisk array (for example, when a spare is done being rebuilt to
replace a failed device, it gets moved from it's current position in the
array to the position it was just rebuilt to replace as part of the
final transition from being rebuilt to being an active, live component
in the array).

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


