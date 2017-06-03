From: Paul Tonelli <paul@tonel.li>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Sun, 4 Jun 2017 00:33:43 +0200
Message-ID: <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170603212011.GA13271@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your answer and your time.

On 06/03/2017 11:20 PM, Andreas Klauer wrote:
> On Sat, Jun 03, 2017 at 09:46:44PM +0200, Paul Tonelli wrote:
>> I am trying to recover an ext4 partition on lvm2 on raid5.
> Okay, your mail is very long, still unclear in places.
>
> This was all done recently? So we do not have to consider that mdadm
> changed its defaults in regards to metadata versions, offsets, ...?
Correct, no change in version of mdadm, kernel, lvm or any other thing, 
mdadm was installed on the machine on the day the raid was created and 
it has not been upgraded since (I checked comparing the apt log 
timestamps and the lvm metadata files).
> In that case I might have good news for you.
> Provided you didn't screw anything else up.
>
>> ```
>> mdadm --create --verbose --force --assume-clean /dev/md0 --level=5
>> --raid-devices=2  /dev/sdb /dev/sdc
>> ```
> You're not really supposed to do that.
> ( https://unix.stackexchange.com/a/131927/30851 )
I know that, now :-/. This was done before the backups.
>
>> I immediately made backups of the three disks to spares using dd
> This is a key point. If those backups are not good, you have lost.
I did backups (just after erasing the raid superblock ), and still have 
them, I have been using them as a reference for all the later tests.
>> I made another mistake during the 3 days I spent trying to recover the
>> data, I switched two disks ids in a dd command and overwrite the first
>> 800Mb or so of disk c:
> Just to confirm, this is somehow not covered by your backups?
Right, this is not covered by my backups. i mistakenly copied from the 
disks I was experimenting with to one of the backup and not the opposite 
once (third mistake is working too late in the evening)

I am still searching for a way to put a complete block device (/dev/sdX) 
read-only for these tests, I believe using overlays is the solution.
>> Part 2: What I tried
>> ====================
> In a data recovery situation there is one thing you should absolutely not do.
> That is writing to your disks. Please use overlays in the future...
> ( https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID#Making_the_harddisks_read-only_using_an_overlay_file )
Point taken, I had done the copy the whole disk way, will try this for 
my next tests.
> Your experiments wrote all sorts of nonsense to your disks.
> As stated above, now it all depends on the backups you made...
Appart from the error just on top, I always used a copy of the original, 
the originals are still available.
>>     - one is missing ~120 GB at the start of the array, I have marked
>> this disk as missing for all my tests
> Maybe good news for you. Provided those backups are still there.
>
> If I understood your story correctly, then this disk has good data.
>
> RAID5 parity is a simple XOR. a XOR b = c
>
> You had a RAID 5 that was fully grown, fully synced.
Actually, this is one question I have: with mdadm, creating a raid5 with 
two disks and then growing it to 3 creates exactly the same structure as 
creating directly a 3 disk raid5 ? Your message seems to say it is the 
same thing.
> You re-created it with the correct drives but wrong disk order.
> This started a sync.
>
> The sync should have done a XOR b = c (only c is written to disk c)
> Wrong order you did c XOR b = a (only a is written to disk a)
>
> It makes no difference. Either way it wrote the data that was already there.
> Merely the data representation (what you got from /dev/md0) was garbage.
>
> As long as you did not write anything to /dev/md0 when you couldn't mount,
> you're good right here. You just have to put the disks in correct order.
>
> Proof:
>
> --- Step 1: RAID Creation ---
>
> # truncate -s 100M a b c
> # losetup --find --show a
> /dev/loop0
> # losetup --find --show b
> /dev/loop1
> # losetup --find --show c
> /dev/loop2
> # mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md42 started.
> # mdadm --wait /dev/md42
> # mkfs.ext4 /dev/md42
> # mount /dev/md42 loop/
> # echo I am selling these fine leather jackets... > loop/somefile.txt
> # umount loop/
> # mdadm --stop /dev/md42
>
> --- Step 2: Foobaring it up (wrong disk order) ---
>
> # mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop2 /dev/loop1 /dev/loop0
> mdadm: /dev/loop2 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
> mdadm: /dev/loop1 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
> mdadm: /dev/loop0 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Sat Jun  3 23:01:31 2017
> Continue creating array? yes
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md42 started.
> # mdadm --wait /dev/md42
> # mount /dev/md42 loop/
> mount: wrong fs type, bad option, bad superblock on /dev/md42,
>         missing codepage or helper program, or other error
>
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> # mdadm --stop /dev/md42
>
> --- Step 3: Pulling the rabbit out of the hat (correct order, even one missing) ---
>
> # mdadm --create /dev/md42 --level=5 --raid-devices=3 /dev/loop0 missing /dev/loop2
> mdadm: /dev/loop0 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Sat Jun  3 23:04:35 2017
> mdadm: /dev/loop2 appears to be part of a raid array:
>         level=raid5 devices=3 ctime=Sat Jun  3 23:04:35 2017
> Continue creating array? yes
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md42 started.
> # mount /dev/md42 loop/
> # cat loop/somefile.txt
> I am selling these fine leather jackets...
Thanks you
>> - I am a the point where hiring somebody / a company with better
>> experience than mine to solve this issue is necessary. If yes who would
>> you advise, if this is an allowed question on the mailing list ?
> Oh. I guess should have asked for money first? Damn.
>
> Seriously though. I don't know if the above will solve your issue.
> It is certainly worth a try. And if it doesn't work it probably means
> something else happened... in that case chances of survival are low.
>
> Pictures (if they are small / unfragmented, with identifiable headers,
> i.e. JPEGs not RAWs) can be recovered but not their filenames / order.
for my case, losing even 20% of the pictures is not an issue, the 
filename / order / directory tree is more important.
>
> Filesystem with first roughly 2GiB missing... filesystems _HATE_ that.
Thank you, so from what you told me, the next steps should be to :
- start using overlays as described in the wiki this will save me a lot 
of time.
   - use the correct disk (with only the raid superblock missing)
   - use the disk which was partially xor-ed during the sync as this has 
no impact on the data
   - do not use the disk with the first GB missing
- try rebuilding the raid with these disks by doing all 6 combinations ?

I will try this tomorrow and update depending on the result.

I have gathered a second question from my unsuccessful tests and search:

Is it possible to copy only a raid superblock from one disk to another 
directly using dd ? after reading on the wiki that the raid superblock 
was 256 bytes long + 2 for each device, I tried:

```
dd if=/dev/sdx of=/dev/sdy count=262 iflag=count_bytes
```

but it did not copy the superblock correctly (mdadm did not find it), 
There may be an offset or something missing.

Thank you again for your time, I will try this tomorrow after a good 
night sleep. It will be less risky.

> Regards
> Andreas Klauer


