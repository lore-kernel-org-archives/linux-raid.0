From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID5 drive failure, please verify my commands
Date: Sun, 16 Jan 2005 13:25:02 -0800
Message-ID: <41EADBAE.6070400@h3c.com>
References: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gerd Knops wrote:
> Hello all,
> 
> One of the dreaded Maxtor SATA drives in my RAID5 failed, after just 3 
> months of light use. Anyhow I neither have the disk capacity nor the 
> money to buy it to make a backup. To make sure I do it correctly, could 
> you folks please double-check my intended course of action? I would 
> really appreciate that.

Failed how? I have tons and tons of Maxtor drives in service, and only 
one actually had a complete failure (verified by their utility, which is 
present on some bootable CD I got called "UltimateBootDisk").

Most of the time its just a bad sector causing a single unreadable 
sector error, which causes the RAID code to kick the drive out. You can 
see what the problem is by using the SMART utilities 
(http://smartmontools.sf.net) - run a long self test 'smartctl -t long 
/dev/sda' to verify things.

I get a bad sector around once a week with maybe 40 250GB drives in 
service, 15 of which are medium to heavy use, all of which get nightly 
short tests and weekly long tests (they usually show up then, hardly 
ever in actual request processing). Usually never the same drive either, 
its pretty random.

One of the problems with Linux + SATA at the moment is that SMART 
doesn't work out of the box, but there are patches available that let it 
work if I recall correctly.

I believe those would be well worth applying if you haven't done so yet, 
as I can't imagine managing a bunch of disks without smartd and the bad 
block howto (google://BadBlockHowto) to fix sectors when they pop up. It 
happens on all disks, its not brand-specific.

Ok, sorry if I'm preaching to a convert, but its one of the few things 
that makes me feel like I'm managing the disks, instead of the opposite. 
Other than that...

> Here is what I think I should be doing:
> 
> - Remove failed disk from array:
> 
>     mdadm /dev/md0 --remove /dev/sda1

Looks relatively correct, although mdadm --manage --remove /dev/md0 
/dev/sda1 would the way I would say it. I do think they're identical 
though - I'm not nitpicking

Someone else mentioned that you can RMA the drive - I'd definitely get 
my money from them if it really was a drive failure. Grab the 
UltimateBootDisk (or make a bootable CD with the Maxtor utility on it) 
and verify the drive with their utility so you can get the magic code 
their website demands before it spits out an RMA.

> - Physically remove disk from system
> - Add new disk to system, partition
> - Add to array:
> 
>     mdadm /dev/md0 --add /dev/sda1

Again, I'd mdadm --manage --add /dev/md0 /dev/sda1, but I'm not sure 
they're any different at all

> Anything else to trigger rebuilding of the disk?

It'll rebuild automagically after the add - make sure the other drives 
don't have bad sectors first though or you'll have a nasty surprise.

I just posted a a script yesterday that makes a bunch of disk files, 
binds them to loop devices and creates a raid set out of them. You could 
use that to practice if you want (though you'd want to change the target 
array name from /dev/md0 to /dev/md1). Practice is always good if you're 
not confident :-). The archives should have it.

> That should be it, correct? Also since I lost all confidence in the 
> Maxtor drives (had a long history of problems with that brand, I don't 
> think any Maxtor drive I ever owned made it to retirement) I probably 

I've only had one Maxtor drive that didn't make it actually, and I don't 
even have good temparature control for a couple of my arrays (40C+ 
temps). Which is just to say that anecdotal evidence isn't worth much. 
Check power, check cooling, and if those are all good, switch brands by 
all means but be ready for more of the same, most likely ;-)

> Also one last question: Foolishly I allocated all available space in the 
> Maxtors for the RAID. Now, should the replacement drive have a slightly 
> smaller capacity, is there some way to deal with that? I think i can use 
> resize2fs to reduce the size of the filesystem (does this work with ext3 
> file systems?). Assuming that works, is there some way to convince the 
> RAID to accept a smaller partition and adjust it's size accordingly?

I'm batting .333 on raidreconf. I'd make sure you get a replacement 
drive of the same size if you can. If you don't, I'd run ext3resize 
*first*, so you shrink the filesystem *before* you shrink the array. 
Then you could try shrinking the array.

What I would really do though (given my recent history with raidreconf), 
assuming you've followed the rule of thumb to never have so much space 
you can't back it up, is to do a full backup, verify the backup, verify 
all the drives (with a smartctl -t long test, or full dd test), then 
attempt the resize, with an eye towards punting and just rebuilding it 
and restoring it if things don't work right.

Hopefully some of this was helpful, good luck resurrecting the array!

-Mike
