From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Hints on reducing kickouts
Date: Thu, 1 Mar 2012 12:22:18 -0600
Message-ID: <20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Obaterspok <john.obaterspok@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 01, 2012 at 07:14:38PM +0100, John Obaterspok wrote:
> Hello,
> 
> Occasionally my system don't shutdown cleanly and almost all time
> mdadm kicks one of the disks on the RAID5 array.
> Is there anything I can do to help prevent this?
> 
> I'm using sw raid 5 with 3 x 3TB Hitachi Deskstar (7K3000 HDS723030ALA640 64MB).
> 
> --------

[snip...]

I'm guessing you're trying to avoid re-syncing a 6TB array in the
event that your host goes down in an un-clean state.  In that
case, I would suggest using a write-intent bitmap on the array.
If you're concerned about loss of performance when using a
bitmap, use an external bitmap that is located on another
spindle(s).

Bryan
