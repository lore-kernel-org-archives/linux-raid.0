From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Strange / inconsistent behavior with mdadm -I -R
Date: Tue, 19 Mar 2013 19:29:44 +0100
Message-ID: <5148AE98.9020203@arcor.de>
References: <51422D10.3040000@arcor.de> <20130318103510.45bdd4a8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130318103510.45bdd4a8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/18/2013 12:35 AM, NeilBrown wrote:

> With -R, it only stays inactive until we have the minimum devices needed for
> a functioning array.  Then it will switch to 'read-auto' or, if the array is
> known and all expected devices are present, it will switch to 'active'.

That's the point - I see the array switch to active *before* all
expected devices are present. That causes further additions to fail.

> Maybe if you could provide a sequence of "mdadm" commands that produces an
> outcome different to what you would expect - that would reduce the chance
> that I get confused.

Here is the sequence of mdadm commands to illustrate what I mean.
I have a RAID10 array and I add the devices using mdadm -I -R in the
sequence 1,3,2,4. After adding device 3, the array will be started in
auto-read-only mode, which is fine.

But then as soon as the next disk (/dev/tosh/rd2) is added, the array
switches to "active" although it is neither written to, nor all disks
have been added yet. Consequently, adding disk 4 fails.

I expected the array to remain "auto-read-only" until either all 4
devices are present, or it is opened for writing. This is how the
container case is behaving (almost - it doesn't switch to active
automatically until it's written to).

# ./mdadm -C /dev/md0 -l 1 -n 4 /dev/tosh/rd[1-4] -pn2
mdadm: array /dev/md0 started.
(wait for initial build to finish)
# mdadm -S /dev/md0
mdadm: stopped /dev/md0
# ./mdadm -v -I /dev/tosh/rd1 -R
mdadm: /dev/tosh/rd1 attached to /dev/md/0, not enough to start (1).
# ./mdadm -v -I /dev/tosh/rd3 -R
mdadm: /dev/tosh/rd3 attached to /dev/md/0, which has been started.
# cat /proc/mdstat
Personalities : [raid1] [raid10]
md0 : active (auto-read-only) raid10 dm-6[2] dm-4[0]
      2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
# ./mdadm -v -I /dev/tosh/rd2 -R; cat /proc/mdstat
mdadm: /dev/tosh/rd2 attached to /dev/md/0 which is already active.
Personalities : [raid1] [raid10]
md0 : active raid10 dm-5[1] dm-6[2] dm-4[0]
      2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
      [>....................]  recovery =  0.0% (0/1047040)
finish=1090.6min speed=0K/sec
(wait for recovery to finish)
# ./mdadm -v -I /dev/tosh/rd4 -R
mdadm: can only add /dev/tosh/rd4 to /dev/md/0 as a spare, and
force-spare is not set.
mdadm: failed to add /dev/tosh/rd4 to existing array /dev/md/0: Invalid
argument.

Thanks,
Martin
