From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID design
Date: Sat, 12 Jul 2003 09:28:44 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0307120912550.6220-100000@unicorn.drogon.net>
References: <000201c3480a$9c7ebbd0$27e703ca@magnus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000201c3480a$9c7ebbd0$27e703ca@magnus>
To: Mikael Chambon <raid-ml@cronos.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Jul 2003, Mikael Chambon wrote:

> Hi All,
> First I wish to thanks you guys for your answers, I really apreciate.
> Now I have a question about RAID design.
>
> I am trying to implement the best soft RAID system for a samba fileserver
> as safer as possible.
>
> Here is my first idea:
>
>  1) Using a small hard drive for the OS (2gigs)
> plugged as IDE 1 master (won't take part of the raid array).
>
> 2) Using two 120 gig for the fileserver in a raid1 array
> The first one will be as IDE1 slave and the second one as
> IDE2 master (the cdrom drive will be IDE2 slave).
>
> The weakness here will be if the first hard drive with the OS
> failed.

It's a double weakness too - it's possible (and I've had it happen to me)
for one drive on a controller to take the other one out with it too. In my
case, when I removed the offending drive, the other drive was OK and
intact, but who knows. So should your data drive fail on the first
controller, it may not only take that out, but your OS disk out too.
Remove the data drive and reboot and it may work, but ...

> My second idea is:

Much better IMO :)

> Use only 2 120 gig hard drives and implement a root raid array including
> the OS. The first one as IDE1 master and the second one as IDE2 master.
> (The cdrom drive as IDE1 slave).

Unless you actually need the CDROM, I'd unplug it.

> I am not RAID expert but I really don't see the benefits of including
> the OS in the RAID array as if the primary HD failed, the system won't be
> able to boot anyway. Am I right ?

Not neccessarily. Modern motherboards will boot of either on-board
controller, so if the primary failed, then the master drive on the 2nd
controller ought to be able to boot. It's worth checking your motherboard
though. All the systems I've built in the past 2-3 years like this have
had this ability. You may need to physically unplug the failed drive
though (and reboot) if it fails in a way that make it look like it's still
active.

> I mean if the primary disk failed, even if I ask the BIOS to boot the second
> hard drive, the system won't boot as everything is linked to hda in the
> system.

Make everything RAID1 then it'll "just work". Not all distributions let
you do this at install time though. I use Debian which doesn't let you do
it at boot time, so it's a little fiddly, but the Root-RAID How-To does
exactly what it says on the tin...

What I'd do: Partition both drives exactly the same and RAID one on all
the partitions. Even swap.  Eg.

Partition	Use	Size
  1		/	512MB
  2		swap	1024M
  3		/usr	2048M
  4		/space	Rest of disk

Unless you anticipate 100's of MB of log files every say you'll be fine
with that. (And if you do, then put /var on its own partition, as big as
you anticipate it being - 4GB is about right for some of the mail servers
I've built like this, but only you know what the expected use of the
machine is) I have several machines built just like this in SMEs and they
work really well with both Samba and NFS exports of the filesystem.

Remember to connect your drives up with 2 x 80-pin cables to take full
advantage of modern DMA - it might also be worth while compiling a custom
kernel too with the right drivers for the motherboard hardware installed,
then you shouldn't need hdparm at boot time.

You might also want to look at a journalling filesystem too. I've only
recently started to use XFS and so-far it's saved me one hour-long FSCK
which is a down-side of ext2 and large partitions )-:

Gordon

