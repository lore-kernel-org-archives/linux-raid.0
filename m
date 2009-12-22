From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Linux MD RAID 1 read performance tunning
Date: Tue, 22 Dec 2009 18:52:25 +0200
Message-ID: <20091222165225.GA2684@rap.rap.dk>
References: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 22, 2009 at 06:34:55PM +0200, Ciprian Dorin, Craciun wrote:
>     Hello all!
> 
>     I've created a 64G RAID 1 matrix from 3 real disks. (I intend to
> use this as a target for backups.)
>     Now while playing around with this array, I've observed that the
> read performance is quite low because it always reads from the disk in
> the first slot (which happens to be the slowest...)
> 
>     So my questions are:
>     * is there any way to tell the MD driver to load-balance the reads
> between the three disks?

It does not make sense to do distributed reading in raid1 for sequential
files. This is because it will not be faster to read from more drives,
as this will only make the reading from one drive skipping blocks on
that drive. In other words, in the time you use for skipping blocks on
one drive, you could just as well have read the blocks. So then better
just read all the blocks off one drive, and then do other possible IO
from other drives.

RAID10 is a modern form of raid1, which can do better distributed
reading, especially raid10,f2 is good for disks, while raid10,o2 may be
better for SSDs.

Best regards
Keld
