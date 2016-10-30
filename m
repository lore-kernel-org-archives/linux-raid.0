From: Peter Hoffmann <Hoffmann.P@gmx.net>
Subject: Panicked and deleted superblock
Date: Sun, 30 Oct 2016 19:23:00 +0100
Message-ID: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My problem is the result of working late and not informing myself
previously, I'm fully aware that I should have had a backup, be less
spontaneous and more cautious.

The initial situation is a RAID-5 array with three disks. I assume it to
look follows:

| Disk 1   | Disk 2   | Disk 3   |
|----------|----------|----------|
|    out   | Block 2  | P(1,2)   |
|    of    | P(3,4)   | Block 4  |	degenerated but working
|   sync   | Block 5  | Block 6  |


Then I started the re-sync:

| Disk 1   | Disk 2   | Disk 3   |
|----------|----------|----------|
| Block 1  | Block 2  | P(1,2)   |
| Block 3  | P(3,4)   | Block 4  |   	already synced
| P(5,6)   | Block 5  | Block 6  |
               . . .
|    out   | Block b  | P(a,b)   |
|    of    | P(c,d)   | Block d  |	not yet synced
|   sync   | Block e  | Block f  |

But I didn't wait for it to finish as I actually wanted to add a fourth
disk and so started a grow process. But I just changed the size of the
array, I didn't actually add the fourth disk (don't ask why I cannot
recall it). I assume that both processes - re-sync  and grow - raced
through the array and did their job.

| Disk 1   | Disk 2   | Disk 3   |
|----------|----------|----------|
| Block 1  | Block 2  | Block 3  |
| Block 4  | Block 5  | P(4,5,6) |	with four disks but degenerated
| Block 7  | P(7,8,9) | Block 8  |
               . . .
| Block a  | Block b  | P(a,b)   |
| Block c  | P(c,d)   | Block d  |	not yet grown but synced
| P(e,f)   | Block e  | Block f  |
               . . .
|    out   | Block V  | P(U,V)   |
|    of    | P(W,X)   | Block X  |		not yet synced
|   sync   | Block Y  | Block Z  |

And after running for a while - my NAS is very slow (partly because all
disks are LUKS'd), mdstat showed around 1GiB of Data processed - we had
a blackout. Water dropped in a distribution socket and *poff*. After a
reboot I wanted to resemble everything, didn't know what I was doing so
the RAID superblock is now lost and I failed to reassemble (this is the
part I really can't recall, I panicked). I never wrote anything to the
actual array so I assume, better hope that no actual data is lost.

I have a plan but wanted to check with you before doing anything stupid
again.
My idea is to look for that magic number of the ext4-fs to find the
beginning of Block 1 on Disk 1, then I would copy an reasonable amount
of data and try to figure out how big Block 1 and hence chunk-size is -
perhaps fsck.ext4 can help do that? After that I copy another reasonable
amount of data from Disks 1-3 to figure out the border between the grown
Stripes and the synced Stripes. And from there on I'd have my data in a
defined state from which I can save the whole file system.
One thing I'm wondering is if I got the layout right. And the other
might be rather a case for the ext4-mailing list but I'd ask it anyway:
how can I figure where the file system starts to be corrupted?

embarrassed Greetings,
Peter Hoffmann

