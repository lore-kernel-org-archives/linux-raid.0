From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: RAID5 recovering
Date: Mon, 15 Apr 2013 17:49:42 +0200
Message-ID: <516C2196.4050308@schinagl.nl>
References: <516C04FB.3030604@inserm.fr> <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Martineau <pierre.martineau@inserm.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15-04-13 17:19, Robin Hill wrote:
> On Mon Apr 15, 2013 at 03:47:39PM +0200, Pierre Martineau wrote:
>
>> Dear Raid experts,
>>
>> I have a Raid5 volume that recently crashed and I need you advices
>> before doing some irreversible action.
>>
>> Let me first summarize the past and current state.
>>
>> 1) I had a nicely running RAID5 volume with 3 x 1 To disks (LVM on top
>> and several LVM volumes in ext3 and axt4) but volume was now a bit too
>> small and I decided to add a new 1 To disk.
>>
> Given the rebuild time for a 1To disk, I'd be wary of running RAID5 - if
> you have the space, adding another disk and going to RAID6 will be much
> safer.
+1
Raid5 is great, it really is, but raid6 is so much more better.
>> 2) I added a new disk and did not do anything for a couple of days (Raid
>> still running with 3 disks)
>>
>> 3) One of the old disk failed and was ejected from the RAID.
>>
>> 4) The ejected disk was not even present as /dev/sdX. I thus tested the
>> connections and the disk came back.
>>
>> 5) I resync the ejected disk and I was back with my original 3 disk array.
>>
>> 6) I waited 2-3 days and everything was fine. I then added the new disk
>> and resync.
>>
>> 7) I had now a running 4 disk RAID5 array, I created a new volume and
>> started copying on it.
>>
>> 8) During the week-end, 2 disks were ejected from the array, the new
>> installed one and the same than previously (step 3)
>>
>> 9) Again the 2 disks were not present in /dev/sdX. I thus checked again
>> the connections and the problem was a molex connector. The two ejected
>> disks were on the same molex and this explains why both were detected as
>> faulty.
>>
>> Now, my list of errors as a newbie.
>>
>> 4) I did not save all the informations before proceeding (mdadm
>> --examine, /etc/mdadm/mdadm.conf, syslog, ...)
>>
>> 5) I tried to assemble the disks with
>> mdadm --assemble --scan
>> with no result
>>
>> 6) I thus tried and this is my big error I think !!!
>> mdadm --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>
>> I forgot in this command /dev/md0 after assemble.
>> Because of this /dev/sdb1 suberblock was removed and now mdadm--examine
>> /dev/sdb1 returns "No md superblock detected on /dev/sdb1"
>>
>> I would like now to be more cautious. If some nice expert from the list
>> would be nice enough to tell me if the proposed method described below
>> is the right approach I will be grateful for the rest of my life :-)
>>
>> 7) I read the RAID wiki and the list.
>>
>> 8) I saved
>> mdadm --examine /dev/sd[bcde]1
>> dmesg
>> syslog
>> /etc/mdadm/mdadm.conf
>> fdisk -lu /dev/sd[bcde]
>>
>> I put the content of this files at the end of this message (except dmesg
>> and syslog because they are very long).
>>
>> 9) /dev/sdd is the new disk. This is clear in the fdisk listing since it
>> is a 4K sector disk.
>> The normal order of the raid is thus (see mdadm --examine /dev/sd[de]1)
>> sdb1 sdc1 sde1 sdd1
>>
>> 10) Events are
>> /dev/sdb1: no md superblock (see 6)
>> /dev/sdc1: Events : 112358
>> /dev/sdd1: Events : 112333
>> /dev/sde1: Events : 112358
>>
>> It seems that sdd was the first disk removed.
>> Presumably sdb1 is in sync since it was running with sdc1 when the sdd1
>> and sde1 were ejected from the array (see 8) but I can't be sure since I
>> stupidly erased its superblock!
>>
>> 11) I propose to re-create the array with the --assume-clean option,
>> then check everything using "fsck -n" and "mount -o ro"
>> the command would be:
>>
>> mdadm --create /dev/md0 -e 0.90 --assume-clean --level=5 --n=4 \
>> --chunk=64 --size=976759936 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd1
>>
> <-- snip -->
>
> Have you tried to force assemble the array first? Recreating the array
> is a risky option, so should be avoided if possible. First try doing:
>    mdadm -Af /dev/md0 /dev/sd[cde]1
I don't know if this would have been the best first course of action. 
You forcibly used the array with a wrong event count. You got lucky this 
time and only had minor corruptions, it could have been much much worse.

You could have examined the superblock first with hexdump -C /dev/sdb1 | 
less

See if it is all actually zero, or just some fields and hopefully could 
be recreated by examining the other disks.

I personally would have trusted the recreation method more. Dump all 
superblocks (as backup! with dd so you can always write it back)! 
recreate it using sd[bce]1 (sdd1 wasn't fully in sync) and fsck -n (read 
only test). If that is okay, read only mount. (I would even mark the 
array  as read-only). If all that works. You have a corrected 3/4 array. 
Re-add sdd1.

If you dump the superblock via dd (some hexdumping juju should give you 
the start of the ext/lvm's and thus upto that point should be dumped, 
about 4MiB i guess) you should have a perfectly acceptable way to get 
your superblocks back into its original state (if needed).

Also, I recall having read on this list that raid5 disk 'order' didn't 
matter? Only with raid6 it apparently mattered.

Anyway, you got it all back, so lucky you :)
>
> If that works then you'll need to re-add (and rebuild) /dev/sdb1. If it
> doesn't work, try rerunning (after making sure the array is stopped) and
> adding "-vvv" for extra verbosity, then send through the output from
> that and anything relevant from dmesg.
>
> HTH,
>      Robin

