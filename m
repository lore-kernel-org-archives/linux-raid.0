From: Phil Turmel <philip@turmel.org>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Sat, 25 Jun 2016 12:49:01 -0400
Message-ID: <576EB5FD.1000309@turmel.org>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
 <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
 <22381.43040.31844.544728@quad.stoffel.home>
 <576E6E68.9070209@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <576E6E68.9070209@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Peter Gebhard <pgeb@seas.upenn.edu>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Another Sillyname <anothersname@googlemail.com>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

Hi Wol, Peter,

{ Convention on kernel.org is to reply-to-all, bottom or interleave
replies, and trim unnecessary context.  CC list fixed up accordingly. }

On 06/25/2016 07:43 AM, Wols Lists wrote:

> I know you're getting conflicting advice, but I'd try to get a good dd
> backup first. I don't know of any utility that will do an md integrity
> check on a ddrescue'd disk :-( so you'd need to do a fsck and hope ...

Conflicting advice indeed.  More conflict ahead:

dd is totally useless for raid recovery in all cases.  ddrescue may be
of use in this case:

If there is redundancy available for proper MD rewrite of UREs, you want
to run the original devices with the UREs, so they'll get fixed.  No
need for dd.  If there's no redundancy available, then you have to fix
the UREs without knowing the correct content, and ddrescue will do that
(putting zeroes in the copy).

> Oh - and make sure you new disks are proper raid - eg WD Red or Seagate
> NAS. And are your current disks proper raid? If not, fix the timeout
> problem and your life *may* be made a lot simpler ...

Yes, timeout mismatch is a common problem and absolutely *must* be
addressed if you run a raid array.  Some older posts of mine that help
explain the issue are linked below.

If you'd like advice on the status of your drives, post the output of:

for x in /dev/sd[defg] ; do echo $x ; smartctl -iA -l scterc $x ; done

> Have you got spare SATA ports? If not, go out and get an add-in card! If
> you can force the array to assemble, and create a temporary six-drive
> array (the two dud ones being assembled with the --replace option to
> move them to two new ones) that may be your best bet at recovery. If md
> can get at a clean read from three drives for each block, then it'll be
> able to rebuild the missing block.

No.  The first drive that dropped out did so more than a year ago --
it's content is totally untrustworthy.  It is only suitable for wipe and
re-use if it is physically still OK.

Which means that the the balance of the drives have no redundancy
available to reconstruct data for any UREs remaining in the array.  If
there were, forced assembly of originals after any timeout mismatch
fixes would be the correct solution.  That would let remaining
redundancy fix UREs while adding more redundancy (the #1 reason for
choosing raid6 over raid5).

Peter, I strongly recommend that you perform a forced assembly on the
three drives, omitting the unit kicked out last year.  (After fixing any
timeout issue, if any.  Very likely, btw.)  Mount the filesystem
read-only and backup the absolutely critical items.  Do not use fsck
yet.  You may encounter UREs that causes some of these copies to fail,
letting you know which files to not trust later.  If you encounter
enough failures to drop the array again, simply repeat the forced
assembly and readonly mount and carry on.

When you've gotten all you can that way, shut down the array and use
ddrescue to duplicate all three drives.  Take the originals out of the
box, and force assemble the new drives.  Run fsck to fix any remaining
errors from zeroed blocks, then mount and backup anything else you need.

If you need to keep costs down, it would be fairly low risk to just
ddrescue the most recent failure onto the oldest (which will write over
any UREs it currently has).  Then forced assemble with it instead.

And add a drive to the array to get back to a redundant operation.
Consider adding another drive after that and reshaping to raid6.  If
your drives really are ok (timeout issue, not physical), then you could
re-use one or more of the originals to get back to full operation.  Use
--zero-superblock on them to allow MD to use them again.

Phil

Readings for timeout mismatch:  (whole threads if possible)

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2

