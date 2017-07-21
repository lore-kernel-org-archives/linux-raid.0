From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Advice please re failed Raid6
Date: Fri, 21 Jul 2017 10:48:08 +0100
Message-ID: <22897.52696.164078.23536@tree.ty.sabi.co.uk>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
        <22892.649.826246.644975@tree.ty.sabi.co.uk>
        <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
        <22895.21096.215892.928052@tree.ty.sabi.co.uk>
        <cf9aac00-91b3-3cb5-bceb-df5d7113b933@gmail.com>
        <ea81b594-9da1-4efb-2c6d-3bf50cf9e3e9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ea81b594-9da1-4efb-2c6d-3bf50cf9e3e9@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Tried different order: sde, sdc, sdd and blkid worked.

It is not clear what "blkid worked" means here. It should have
reported an 'ext4' filesystem.

>> Added sdb as you suggested.

I actually wrote: "try a different order or 3-way subset of
'sd[bcde]'." Perhaps "3-way subset" was not clear. Only when the
right subset in the right order were found adding a fourth
member was worth it.

Also it matter enormously whether "Added sdb" was done after
recreating the set with four members with 'missing' or just 3.
It is not clear what you have done.

Also I had written: "not clear to me whether the 'mdadm' daemon
instance triggered a 'check' or a 'repair'" and you seem to have
not looked into that.

Also I had written: "I hope that you disabled that in the
meantime" and it is not clear whether you have done so.

Also I had written: "Trigger a 'check' and see if the set is
consistent", and I have no idea whether that happened and what
the result was.

Your actions and reports seem to be somewhat lackadaisical and
distracted as to what is a quite subtle situation.

>> Currently rebuilding.

Adding back 'sdb' and rebuilding: you can leave that to the
point where you have found the right order. Also before adding
'sdb' you would have used 'wipefs'/'mdadm --zero' it, I hope.

> Peter, here is where I come unstuck.  Where to from here?
> Raid6 has rebuilt, apparently successfully, but I can't mount.

It's difficult to say, because it is not clear what is going on,
because if the right order of members is (sdb sde sdc sdd) the
original output of 'mdadm --examine' is not consistent with that.

The issue here continues to be what is the right order of the
devices as members, and I am not sure that you know which
devices are which. I don't know how accurate are your reports
as to what happened and as to what you are doing.

> [29458.547989]  disk 0, o:1, dev:sde
> [29458.547995]  disk 1, o:1, dev:sdc
> [29458.548001]  disk 2, o:1, dev:sdd
> [29458.548007]  disk 3, o:1, dev:sdb

To me it seems pretty unlikely that 'sdb' would be member 3, but
again given your conflicting information as to past and current
actions, I cannot guess what is really going on.

But then your situation should be pretty easy: according to your
reports, you have a set of 4 devices in RAID6, which means that
any 2 devices of the 4 are sufficient to make the set work. The
only problem is knowing in which positions.

For the first stripe, the first 512KiB on each drive, the layout
will be:

     member 0: the first 512KiB of the 'ext4', with the superblock.
     member 1: the second 512KiB of the 'ext4', with a distinctive layout.
     member 2: 512KiB of P (XOR parity), looking like gibberish.
     member 3: 512KiB of Q (syndrome), looking like gibberish.

It might be interesting to see the output of:

   for D in c d e
   do
     echo
     echo "*** $D"
     blkid /dev/sd$D
     dd bs=512K count=1 if=/dev/sd$D | file -
     dd bs=512K count=1 if=/dev/sd$D | strings -a
   done
