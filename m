From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Wed, 29 Oct 2014 12:45:34 +0530
Message-ID: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm outlining below a proposal for a RAID device mapper virtual block
device for the kernel which adds "split raid" functionality on an
incremental batch basis for a home media server/archived content which
is rarely accessed.

Given a set of N+X block devices (of the same size but smallest common
size wins)

the SplitRAID device mapper device generates virtual devices which are
passthrough for N devices and write a Batched/Delayed checksum into
the X devices so as to allow offline recovery of block on the N
devices in case of a single disk failure.

Advantages over conventional RAID:

- Disks can be spun down reducing wear and tear over MD RAID Levels
(such as 1, 10, 5,6) in the case of rarely accessed archival content

- Prevent catastrophic data loss for multiple device failure since
each block device is independent and hence unlike MD RAID will only
lose data incrementally.

- Performance degradation for writes can be achieved by keeping the
checksum update asynchronous and delaying the fsync to the checksum
block device.

In the event of improper shutdown the checksum may not have all the
updated data but will be mostly up to date which is often acceptable
for home media server requirements. A flag can be set in case the
checksum block device was shutdown properly indicating that  a full
checksum rebuild is not required.

Existing solutions considered:

- SnapRAID (http://snapraid.sourceforge.net/) which is a snapshot
based scheme (Its advantages are that its in user space and has cross
platform support but has the huge disadvantage of every checksum being
done from scratch slowing the system, causing immense wear and tear on
every snapshot and also losing any information updates upto the
snapshot point etc)

I'd like to get opinions on the pros and cons of this proposal from
more experienced people on the list to redirect suitably on the
following questions:

- Maybe this can already be done using the block devices available in
the kernel?

- If not, Device mapper the right API to use? (I think so)

- What would be the best block devices code to look at to implement?

Neil, would appreciate your weighing in on this.

Regards,

Anshuman Aggarwal
