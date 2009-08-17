From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Software, Raid 5, Different Size Drives.
Date: Sun, 16 Aug 2009 23:46:32 -0500
Message-ID: <20090817044642546.ETRX6077@cdptpa-omta04.mail.rr.com>
References: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Can anyone tell me what truth there is in this? Should I actually create
> a
> > partition  that is always going to be a nice multiple size smaller so i
> > can smooth over the bumps?
> 
> Personally I never create a single partition for an md array.  I either
> use the whole drive, or create a number of partitions for different
> arrays.  I also avoid in-kernel autodetect.

	Although I am nowhere nearly the expert Neil is, I'm going to add my
support to his post.  I'm much more familiar with flavors of Unix than with
Linux, but my experience strongly suggests what he says is true.  With a
single drive system, partitions are effectively mandatory, but once one
decides to implement a  multiple drive system, in my estimation the paradigm
changes.  If your implementation requires more than one array to be built
from several common disks, then partitioning is required, but if practical I
prefer to build systems with the main data area supplied by an array of
whole disks.  Of course, there are a number of variations of even this
theme, but personally I like to build a rather small OS disk containing the
root, /var, /etc, and so forth.  Sometimes I will create a separate
partition for /boot.  The rest I put on a single large RAID array of whole
disks with no partitions under or above the array.  Although RAID solutions
are certainly possible for the OS areas, I personally prefer to not
implement RAID for the OS, and simply keep a cold spare drive around with
regular backups of the OS configuration kept online.  It's also been my
experience that, all things considered, it's generally best to limit the
number of partitions as much as possible.  Of course, there can be some
performance penalty involved, and valid arguments can be made for creating
specific partitions to meet various needs.

> The question of what "best" may well come down to the start up scripts
> that your distro uses and any hidden assumptions that might be in them...
> 
> I guess that isn't very helpful though... I can say that either approach
> can be made to work fine.  The one issue that you particularly need to be
> careful off is the boot sector.  Partitions always leave room for a boot
> sector.  If you don't use partitions and you want a separate boot sector,
> then v1.2 metadata is the thing to choose....

	Yeah, what he said.  What's more, booting from an array presents
it's own special requirements.  While it is certainly possible to arrange to
meet all the requirements for booting from an array, unless one is working
with an embedded application, or an enclosure with limited power and / or
drive slots, I much prefer to simply circumvent the issue by booting from a
relatively small, very inexpensive drive and making the data area as simple,
straightforward, and primitive as possible.  If the drive dies, I replace
it.  'No big deal.

