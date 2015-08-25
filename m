From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Tue, 25 Aug 2015 12:18:41 -0600
Message-ID: <7678934.VNkHgNqiIX@balsa>
References: <1817382.9YhZ7ff5Yl@balsa> <55C8E92F.5020700@youngman.org.uk> <65422527.2R17mF7xfV@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65422527.2R17mF7xfV@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon 10 Aug 2015 12:42:35 PM Thomas Fjellstrom wrote:
> On Mon 10 Aug 2015 07:10:55 PM Wols Lists wrote:
> > On 10/08/15 18:44, Thomas Fjellstrom wrote:
> > > On Mon 10 Aug 2015 11:35:13 AM Mikael Abrahamsson wrote:
> > >> On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:
> > >>> I did try that :( It fails to assemble because it only sees sdc as a
> > >>> spare.
> > >>> Maybe because I did things with the old mdadm first, and did a
> > >>> --remove?
> > >>> That seems to have wiped out the "slot" information (it's -1) so the
> > >>> assemble force magic can't figure things out? Just a guess on my part.
> > >> 
> > >> Unless someone else has a better idea, I'd say you're right. If you
> > >> would
> > >> have unplugged the failed drive (so it disappeared completely), it
> > >> could
> > >> probably have been re-added. So unless you have a copy of the old
> > >> superblock, your only way to proceed now is to use --create
> > >> --assume-clean
> > >> and get all the parameters right (order, offsets etc). There are lots
> > >> of
> > >> examples in the mailing list archives of people trying this and some
> > >> actually suceeding.
> > > 
> > > I think the only thing that would stop that from working is that there
> > > is
> > > data in the bitmap. So if a assume clean is done, it might ignore that
> > > and cause some extra corruption?
> > 
> > Which is why you use loopback devices. You'll need to look back at
> > previous posts to see how to do it, but you put a pseudo-layer over the
> > real disks (which never actually get written to), and you can then fsck
> > your array. If that comes up clean, you know you got the assemble
> > parameters right, and you can shut down the pseudo-array and assemble
> > the real array.
> > 
> > > It'd be interesting to figure out if i can set that slot number manually
> > > or
> > > with a tool. That might be a smarter/safer way of doing it.
> > 
> > Better the pseudo way (which will definitely allow you to recover IF the
> > disk isn't corrupted) than trying your own stuff which might write to
> > the disk and make life harder/impossible to recover.
> 
> Yeah, I did that once previously for a recovery. It was quite handy. I
> backed everything up to a different machine. And re-created the array.
> 
> I may do that again. But then I actually have a mostly full backup, about
> the only things i care about is some pictures I added to the array before
> it went down, that I still have a copy of, but would have to copy them all
> back off of various devices.

Turns out, I couldn't rescue the data off that array. I looked harder at the 
kernel logs, and it appears it started to rebuild then was immediately 
interrupted and something tells me that somehow scrambled the beginning of the 
array, and the metadata? I don't know. I tried a bunch of different create 
orders on loop back devices, and nothing would work. I did get one order to 
partially work, XFS claimed it could see the fs, but xfs_check was having a 
fit, so I gave up. I spent too much time trying to get it to work.

I only lost some work that I can re do, so it isn't an issue. I had a semi 
recent backup, only about a few days older than the failure, and the work I 
lost was some picture sorting from a trip i took at the end of july, and all 
of the pictures are still on my camera and phone, so all is good.

For kicks, I installed ZFS on my nas, going to give that a try. My backup is 
still mdraid. Interestingly the backup array dumped two disks near the same 
time. I'm suspecting the controllers REALLY don't like driving deffective 
disks. I installed the 2TB disk that dropped out of the NAS that initially 
seemed fine, but then started freaking out after sitting there doing nothing 
for a while, and the controller booted another drive that seems to be working 
fine and is a brand new WD-Red that I did some semi-serious burn-in testing on 
prior to putting it into service. Just in case, that WD is getting some more 
testing done before I add it back to the RAID-6 array it came from. It was 
strange though, after the controller reset the likely bad 2TB seagate i only 
put in there to test, it immediately started having problems with the 3TB WD, 
and then reset that... I'm starting to suspect these IBM M1050's do not have 
the most robust error handling.

Anyhow, problem solved for now.
 
> > Cheers,
> > Wol

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
