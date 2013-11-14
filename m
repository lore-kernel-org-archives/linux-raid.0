From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Thu, 14 Nov 2013 17:09:22 +0100
Message-ID: <5284F5B2.3040307@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm> <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com> <52848D5C.7020701@shiftmail.org> <002201cee126$5c390290$14ab07b0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002201cee126$5c390290$14ab07b0$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'Bernd Schubert' <bernd.schubert@fastmail.fm>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/11/2013 11:43, Justin Piszcz wrote:
> $ cat /sys/devices/virtual/block/md1/md/mismatch_cnt
> 303232
>
> Ready to test again, mismatch_cnt very high..
>
> [ .. ]
>
> Please see the following per your new instructions:
> http://home.comcast.net/~jpiszcz/20131114/joystick_cmds2.txt
>
> Summary: No diffs found.

mmh that's strange...

At the end of the procedure (like now, if you didn't resync or repair in 
the meanwhile) is mismatch_cnt still so high?
I'm wondering if a resync happened anyway somehow notwithstanding the 
procedure seems correct to me this time.


>>> What kernel version is yours?
> Was using system rescue cd 3.7.0, appears to be 3.4.47.

no, not that one...
it would be helpful to know the kernel version that *creates* 
mismatches, the one that you have running normally on the live system.
That's the "bugged" one, supposing this is really a bug (until we find 
where the mismatches are, it's difficult to say wether this is a data 
loss or not)


> Will re-try with the latest system rescue cd, 3.8.1, appears to be 3.4.66.
no, that's not needed...


> On a side note, I have not seen any corruption on any of my files; debsums also confirms no issues with any of the system files, so I am wondering if mismatch_cnt is accurate based on the diff above and not seeing any corruption?

yep the problem is now in fact to understand WHERE these mismatches are 
hiding...

Ubuntu files are mostly executables and config files which do not get 
changed often. Mismatches there are less likely to be there than in the 
files which do indeed change.

Maybe the mismatched are located ext4 metadata areas which are not files 
and so can't be seen with md5sums... That would still be as much 
worrisome, unless some expert of ext4 can tell that it's ok (it can be 
OK if the region with mismatches is an old metadata area, currently 
unused; the mechanism that can create harmless mismatches in this case 
has been described by Neil)

It seems you will need to perform the other test I described previously. 
A bit more complex, but it should find something. This can be done live, 
or at least the beginning of it:

- First confirm that mismatch_cnt is still high..

- Then if this does not disrupt your system operation too much, i would 
suggest to fill 95% of free space with a zeroes file like you did in 
earlier tests. Otherwise for a mismatch happening in non-file area we 
won't be sure of what kind of area is that. Maybe recompute mismatch_cnt 
after this.

then, copypasting the procedure with some modifications:
----
... to determine the location of mismatches (...)
Unfortunately I don't think MD tells you the location of mismatches 
directly. Do you want to try the following:
/sys/block/md1/md/sync_min and /sys/block/md1/md/sync_max should allow 
you to narrow the region of the next check.
Set them, then perform check, then cat mismatch_cnt.
Narrow progressively sync_min and sync_max so that you identify the most 
dense areas of mismatches, or a few single blocks that mismatch.
When you have identified some regions or isolated blocks, invoke "sync" 
from bash and then check again the same region a couple of times so to 
be sure that it stays mismatched and it's not just a transient situation.
Then try with debugfs (in readonly mode can be used with fs mounted): 
there should be an option to get the inode number from a block number of 
the device... I hope that block numbers are not offset by MD... I think 
it's icheck and after that you might need "find -inum <inode_number>" 
launched on the same filesystem to find the corresponding filename from 
the inode number. That should be the file that contains the mismatch.
----

Try to report here what you find.
If the mismatching regions do not correspond to files (that would agree 
with your previous test), somebody expert of ext4 might be able to tell 
what do they correspond to.

Regards
J.



