From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with assembling a stopped array
Date: Fri, 15 Jul 2016 17:44:57 -0400
Message-ID: <4f7c5ad9-5b63-6060-f6ec-1e9a82bb2b27@turmel.org>
References: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
 <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org>
 <CANz1=TEdGxvDo8WRfCwQy4Ymar2Oo7Ct9acBYJcz06XpaFM15w@mail.gmail.com>
 <69b8afa7-bfeb-e85a-aba6-b6013b2302aa@turmel.org>
 <CANz1=THkLw6tEYxPhEwb2WTfhfuRXu2E1--tAPGV2hmSSLpyLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz1=THkLw6tEYxPhEwb2WTfhfuRXu2E1--tAPGV2hmSSLpyLQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vegard Haugland <vegard@haugland.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Vegard,

On 07/15/2016 01:02 PM, Vegard Haugland wrote:
>> This time, omit the drive that shows up as "spare".  Use all nine
>> others.  You really want nine, so the redundancy in your array can
>> reconstruct when it hits the UREs you obviously have.  See "Current
>> Pending Sector" != 0 in your smartctl reports.
>>
>> After it assembles the nine, issue "mdadm --run /dev/md4" if it didn't
>> start.  Then "echo check >>/sys/block/md4/md/sync_action".
>>
>> Wait for that to finish.  Then add the spare back to the array.
> 
> OK. Here's whats been happening for the past two days. I can this
> command to rebuild the array
> 
> # mdadm -A /dev/md4 /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3
> /dev/sdg3 /dev/sdh3 /dev/sdi3 /dev/sdj3 --force
> mdadm: forcing event count in /dev/sdc3(4) from 32679348 upto 32680549
> mdadm: forcing event count in /dev/sdd3(3) from 32677935 upto 32680549
> mdadm: clearing FAULTY flag for device 3 in /dev/md4 for /dev/sdd3
> mdadm: clearing FAULTY flag for device 2 in /dev/md4 for /dev/sdc3
> mdadm: Marking array /dev/md4 as 'clean'
> mdadm: /dev/md4 has been started with 8 drives (out of 10) and 1 spare.

Well, that sucks.  I expected 9 drives out of 10 and no spare.  You are
somewhat screwed.

> As the output mentioned, the array started and I got access to the
> data again. Yay! In order to start the rebuild, I ran "echo check
>>> /sys/block/md4/md/sync_action".
> 
> The array just finished the rebuild, but not with the results I hoped
> for. Here's the output from mdadm -D /dev/md4

You can't successfully check or rebuild without redundancy if any device
has an Unrecoverable Read Error.  Which you know you have because
Pending is greater than zero on sdc (maybe others, I didn't check).

> For some reason, the other faulty disk (not the one mentioned below,
> or the one that initially showed up as spare) also shows up as spare
> now (like the good one did earlier). Issuing "echo check >>
> /sys/block/md4/md/sync_action" does not make any attempts to rebuild
> the array. Should I use mdadm --manage --add to re-add it before I
> replace the faulty disk with a new one?

It is possible your mdadm is too old to fully --force assembly in this
case, or it is a side effect of old v0.90 metadata.  With v1.x+ and
bitmaps, re-add is very fast and unlikely to hit other UREs.  Too late
for you.

Anyways, you can only use the eight non-spare drives.  Since at least
one has a URE, you will need to use ddrescue to complete copy those
drives onto new drives (or your "spares" with their superblocks erased).
 Then assemble the array (8 members) with the new drives and the non-URE
old drives.  Then add spares one at a time, waiting for rebuild to
finish for each.

If you have very critical data you want to make sure you retrieve,
assemble the eight non-spare drives one more time before making copies,
*don't* do the check, then mount and copy those critical files.  Might
hit a URE anyways, but is the best way to get a quick backup.

Once you start copying devices, be very careful that you keep copies and
roles straight, so that you don't try to assemble with two devices with
the same role number.

You *will* lose some data where the UREs are.  You'll need to fsck to
fix the corruption, if it happens to be in a file or folder.

Phil
