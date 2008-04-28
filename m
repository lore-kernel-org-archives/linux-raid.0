From: "David Lethe" <david@santools.com>
Subject: RE: degraded array after reboot *again*
Date: Mon, 28 Apr 2008 08:06:51 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C197159@34093-C3-EVS3.exchange.rackspace.com>
References: <200804281424.33558.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <200804281424.33558.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Dexter Filmore
Sent: Monday, April 28, 2008 7:24 AM
To: linux-raid@vger.kernel.org
Subject: degraded array after reboot *again*

After migrating my file server from slackware to debian etch it has been
running flawlessly for weeks.

Now yesterday I moved from the 4x250-raid5 to 5x500. 
The machine has two controller, *both* Silicon Image 3114, one onboard
(Asus mobo), one on a PCI controller card.

The 4 drives sat on the onboard controller solely, for the 5 drive array
I had to use one of the PCI controller ports.

Synced the array, installed lvm2, some xfs, copied tha data, all seemed
fine.
Till I rebooted today.
Array degraded, one drive kicked. mdadm -E shows event count mismatch.

Now if anyone knows what to make of this, please replay. Since the
onboard controller and the card controller have the same chip they are
handled by the same kernel module, so I wouldn't know how the external
controller can be an issue.

Only thing I noticed: I use the 2.6.22 from etch-backports bcause 2.6.28
failed to see all partitions. The last message is about one disk not
being spun down properly and that I ought to update the shutdown
utility.

Googling aroung I dug up this:

"As I said above, if you are very nervous, then the easiest complete fix
is to downgrade your kernel (say to 2.6.18-5 from Etch). I'm not an
expert on the issue, but here's my rough understanding: the kernel (as
of 2.6.22) issues a shutdown sequence and the operating system also
initiates a shutdown sequence (as it always used to). The two
overlapping sequences get f&*$%ed up (that's the technical term), and
the system can (1) get told (by one side) to spindown, (2) get a command
(from the other side) that causes it to spin up again and then (3) get a
final command to shut down entirely (and quickly?!?). The result is a
hard change in direction that can cause a noticeable clunk on some
drives. You do that enough times and your drive is f&*$%ed. However, a
few people on a kernel irc channel said that "enough times" means in the
hundreds. "

From
http://www.linuxquestions.org/questions/debian-26/disk-might-not-be-spun
-down-properly.-update-shutdown-utility-583307/

Never was an issue tho with the 4-drive-array.


Attached: mdadm -E from before the resync and the current dmesg.
=================================================================
Just because you use the same chipset & kernel does not mean you have
same functionality, nor does it mean both chipsets have same metadata
layout.  The motherboard and PCI board manufacturer is each responsible
for their own firmware.  I would not be so quick to eliminate an
inherent incompatibility issue as root cause.   The SI RAID chipset,
like all RAID chipsets, make it easier for a developer to create a
controller from scratch, but they still only provide a RAID-centric
instruction set.  The developer sends an opcode to rebuild a stripe, but
the developer must supply a range of blocks to the command.  Startblock,
endblock, and metadata size, along with metadata format have to match or
you either lose data, or metadata gets interpreted by the new controller
as filesystem data.   

This is just one example of how things can differ, there are many more
parameters to consider.  If you have not already done so, turn
everything off, and research whether or not your data was corrupted due
to different RAID implementations.  One technique is to get some scratch
disks, zero them, then build raidsets & stuff them with known data, use
dd to look at raw data on disks, and repeat with the other controller &
compare.  It is a  pain but don't bother asking manufacturers for
specifics on their implementation, they won't tell you unless you are
either a board or RAID software developer .. and then only under NDA.

As for recovery, any command that writes to any disk has potential to
create further damage, so if it was me, I'd limit myself to disk
diagnostics and doing detective work to see what data is actually there.
Use dd to get to raw blocks and see if the RAID parity blocking and
locations make sense, and your data from missing partition is where it
should be.  This is not easy to do if you are inexperienced in this
area, and writing a tutorial isn't anything I am interested in doing.
Suffice to say that the practical way to do this is by using technique I
stated earlier, effectively reverse-engineer the architecture by telling
the RAID controller to "RAID" a known configuration.  (Other techniques
involve writing more sophisticated code like XOR validation, using data
pattern analysis across parity thresholds, or paying somebody to look at
the data.  Of course this still could be nothing more than a cabling
problem,  so run hardware diagnostics first, but do NOT use md driver.
Boot system to a CDROM LINUX image so you don't risk further
destruction)

David @ SANtools ^ com


