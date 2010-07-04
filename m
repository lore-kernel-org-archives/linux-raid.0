From: Niobos <niobos@dest-unreach.be>
Subject: Re: List of mismatched blocks?
Date: Sun, 04 Jul 2010 12:16:57 +0200
Message-ID: <i0pn2r$nir$1@dough.gmane.org>
References: <i0nr7l$jge$1@dough.gmane.org> <slrni2vate.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrni2vate.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-07-03 23:29, Mario 'BitKoenig' Holbe wrote:
> Niobos <niobos@dest-unreach.be> wrote:
>> Weekly, I'm checking my RAID1 array using:
>> Every few weeks, I get a mismatch count (which are easily solved with a
> 
> Which kernel version and which filesystem on top of the RAID1?

Linux serv02.<omitted> 2.6.31-15-server #50-Ubuntu SMP Tue Nov 10
15:50:36 UTC 2009 x86_64 GNU/Linux

/dev/md1 on / type ext3 (rw,errors=remount-ro)


>> "sync"). Is there an easy way to get a list of blocknumbers that
>> mismatch? I'd like to figure out what may be causing this mismatch.
> 
> You can just cmp -l your component devices and get a list of addresses
> and mismatches - easy to convert to block numbers. For ext2/3 I'd bet
> the mismatches are in inode blocks.
I found out about cmp -l, but that gives me roughly 9 million differing
bytes. They are nicely grouped in ranges, but I was hoping for a way
that would output "sectors 517-523 and 4554-4559" or similar.

For the few mismatches that I calculated manually, the mismatching file
seems to be the ext3-journal itself.

I'm running cmp on an active RAID. My guess is that this cause a large
number of false positives: cmp reading both members at a different time,
and hence reading a different version. That was the main reason to ask
for another way to get the mismatching blocks through the raid-layer.

Niobos

PS: Both disks report "rellocated sector count = 0" via SMART.

