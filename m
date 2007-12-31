From: "Marc MERLIN" <merlin@gmail.com>
Subject: Last ditch plea on remote double raid5 disk failure
Date: Mon, 31 Dec 2007 11:39:41 +0100
Message-ID: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

Sorry for the direct Ccs, I'm not sure if my Email to linux-raid will
make it or not.

Long story short, my main server just died with a double raid failure
today, and I'm on vacation on the other side of the world.
One drive is dead for good, the other one generates an error when I
read at least one block, but seems ok otherwise.
Before I look into doing a remote manual server failover/rebuild over
new years eve :(  I was wondering if I can tell the kernel not to kick
a drive out of an array if it sees a block error and just return the
block error upstream, but continue otherwise (all my partitions are on
a raid5 array, with lvm on top, so even if I were to lose a partition,
I would still be likely to get the other ones back up if I can stop
the auto kicking-out and killing the md array feature).

Currently, I get:
/dev/intraid5/usr: recovering journal
sd 0:0:3:0: SCSI error: return code = 0x8000002
sdd: Current: sense key: Medium Error
    Additional sense: Unrecovered read error
Info fld=0x89a48
end_request: I/O error, dev sdd, sector 563784
raid5: Disk failure on sdd3, disabling device. Operation continuing on 3 devices
Buffer I/O error on device dm-0, logical block 541

I'm hoping that if I can get raid5 to continue despite the errors, I
can bring back up enough of the server to continue, a bit like the
remount-ro option in ext2/ext3.

If not, oh well...

Thanks,
Marc
