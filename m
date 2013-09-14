From: Martin Wilck <mwilck@arcor.de>
Subject: "detect reshape on array start" (was Re: Weirdness with DDF arrays
 (mdadm 3.3))
Date: Sat, 14 Sep 2013 23:01:31 +0200
Message-ID: <5234CEAB.1090808@arcor.de>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com> <52346FB1.2020205@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52346FB1.2020205@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: adam.kwolek@intel.com
List-Id: linux-raid.ids

Hi Neil,

I wrote:

>> > Still testing MD arrays using DDF metadata and find another possible issues :)
>> > 
>> > I'm creating a new DDF array containing 2 disks. After that
>> > /proc/mdstat looks correct:
>> > 
>> > # cat /proc/mdstat
>> > Personalities : [raid1]
>> > md124 : active raid1 loop0[1] loop1[0]
>> >       84416 blocks super external:/md125/0 [2/2] [UU]
>> > 
>> > md125 : inactive loop1[1](S) loop0[0](S)
>> >       65536 blocks super external:ddf
>> > 
>> > Now I'm stopping the array and restart it by incrementaly adding the 2 disks:
>> > # mdadm --stop /dev/md124
>> > # mdadm --stop /dev/md125
>> > # mdadm -IRs /dev/loop0
> This is wrong, because -IRs "wills can the mapfile for arrays that are
> being incrementally assembled snd will try to start any that are not
> already started".
> 
> mdadm -IRs will first add /dev/loop0, then see that there is an
> incomplete array, and start it.
> 
>> > # mdadm -IRs /dev/loop1
> Now you add /dev/loop1, but as the array is already started, it will be
> added as a spare. That's what you see below.
> 
> However, there is room for improvement here. The array hasn't been
> written to, so even if it is started, it should be possible to re-add
> the second disk cleanly.

one major problem here seems to be commit 4867e068. It sets the array
dirty after transition from inactive to e.g. read-auto. That seems to be
wrong to me. From the patch's description

  Raid0: detect reshape on array start

  When raid0 array is takeovered to raid4 for reshape it should be
  possible to detect that array for reshape is monitored now for
  metadata update."

it seems that has been made for is a pretty special case (reshape of
RAID0 to RAID4, or would that affect other target geometries as well?)

For experimenting, I reverted the patch and ran some of the IMSM test
cases for reshape of RAID0 to something else, and they all still succeed.

So, I believe this patch can be reverted; and it should be because the
side effect that once a disk is missing when an array is started, it
can't be cleanly added any more, even if the array was never written to.

I cc'd Adam, the author of that patch, on this mail.

Martin
