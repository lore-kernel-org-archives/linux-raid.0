From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Mon, 19 Nov 2012 12:12:24 -0500
Message-ID: <50AA6878.1010002@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com> <50A8F247.8060002@turmel.org> <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com> <50A91487.70806@turmel.org> <CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com> <50A92F53.5080100@turmel.org> <CAPAnFc_siNMWcYtYf56dYO1LgkCKPxMDhC-PuMD-18D4jNJcqw@mail.gmail.com> <50AA36AD.4080100@turmel.org> <CAPAnFc8WG9cH=MvqpdM830kNeoE2TuT3HcMh0u+m23EqOKvdeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc8WG9cH=MvqpdM830kNeoE2TuT3HcMh0u+m23EqOKvdeQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/19/2012 11:44 AM, Drew Reusser wrote:
> On Mon, Nov 19, 2012 at 1:39 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> So you've re-created the MD array.  That's bad.  Chunk size and Data
>> offset size and alignment defaults have changed in the past couple
>> years, so re-creating an array with a different mdadm version can cause
>> these problems.  You can also lose the original order of devices, with
>> similar consequences.
>>
> 
> Yes I did multiple creates to try to get the devices back together
> after mdadm --Fail commands.  I did not know about the assemble
> command yet and was following what "experts" were saying to try to
> recover failed superblock errors after a reboot (which is what errors
> I found).

The odds of success have dropped.  If you used "--assume-clean" *every*
time you used "--create", the odds are still greater than zero.
Otherwise, the odds your data is destroyed is *very* high.

>> (Side note:  there's various pieces of advice floating around the
>> internet on recovering a broken array that start with re-creating the
>> array.  It's horribly wrong, and only a last resort, and only after
>> recording all the details about the original array.)
>>
>> Unless you kept a copy of "mdadm --examine /dev/sd[abde]1" for the
>> original array, this will be difficult to debug further.  Your best
>> chance is to go back to the version of mdadm available when you first
>> built the system and recreate with that, trying the various device order
>> combinations.
>>
>> Don't attempt to mount to check for success.  First, use "fsck -n" to
>> non-destructively check the FS.  If that gives few errors, then you can
>> mount the FS.
>>
>> Phil
> 
> I don't have the original mdadm --examine as I never knew to keep a
> copy of it.  I created this array when I installed Mint on this server
> in August, so the the version I am running now is the same as the
> version on the pen drive I am booting from.  I know the disks were all
> the same.  I set them up intentionally so they would be identical.
> 
> here is the output of the fsck ..
> 
> mint mnt # fsck -n /dev/md0
> fsck from util-linux 2.20.1
> fsck: fsck.linux_raid_member: not found
> fsck: error 2 while executing fsck.linux_raid_member for /dev/md0

So, mount doesn't see it as an ext4 device at all.  Stop the array, and
scan each member for ext4 superblock magic:

for x in /dev/sd[abde]1 ; do echo $x ; \
dd if=$x bs=1M count=256 2>/dev/null | \
hexdump -C |grep '30  .\+  53 ef 0' ; done

Hopefully, each device will show one or more superblock candidates whose
offsets may help us decide which roles are which, and at what data offset.

Phil
