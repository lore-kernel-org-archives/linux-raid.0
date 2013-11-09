From: Doug Ledford <dledford@redhat.com>
Subject: Re: Seagate black armour recovery
Date: Sat, 09 Nov 2013 02:25:22 -0500
Message-ID: <527DE362.5060509@redhat.com>
References: <CAHwiqHszJWNRZqWuarzJZO8cYqQitUoJ+SeLUco64Po=FA3doQ@mail.gmail.com>	<52781F71.4060105@turmel.org> <CAHwiqHsCOzUgktC7DGMXELE0P8kFXbNBji6na0oXfdEWzY4ijg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHwiqHsCOzUgktC7DGMXELE0P8kFXbNBji6na0oXfdEWzY4ijg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Wilson <kevin@digitalarchitects.co.za>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Morne Botha <bothamb@gmail.com>, Neil Brown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

On 11/05/2013 02:39 PM, Kevin Wilson wrote:
> Hi Phil,
> Thanks for the quick reply. I should have, as you correctly stated,
> included the result from trying to force assemble.
> mdadm: looking for devices for /dev/md3
> mdadm: /dev/sda4 is identified as a member of /dev/md3, slot 0.
> mdadm: /dev/sdb4 is identified as a member of /dev/md3, slot 1.
> mdadm: /dev/sdc4 is identified as a member of /dev/md3, slot 2.
> mdadm: ignoring /dev/sdb4 as it reports /dev/sda4 as failed
> mdadm: ignoring /dev/sdc4 as it reports /dev/sda4 as failed
> mdadm: no uptodate device for slot 1 of /dev/md3
> mdadm: no uptodate device for slot 2 of /dev/md3
> mdadm: no uptodate device for slot 3 of /dev/md3
> mdadm: added /dev/sda4 to /dev/md3 as 0
> mdadm: /dev/md3 assembled from 1 drive - not enough to start the array.
>
> I was then trying to edit the Array status in sdb4 and sdc4 due to the
> two lines ignoring /dev/sd[x]4 as it reports...
> The man pages suggest using the --update=summaries with a list of the
> devices, however I get an error that states that this is not valid for
> 1.X superblock versions.

Hmmm...this looks like a legitimate bug in the raid superblock update 
code.  I'm putting Neil on the Cc: of this email so he doesn't 
accidentally overlook this issue.

So, as I see it, the bug (which is present in your mdadm -E output 
below, and confirmed in the dmesg output above) is that at some point in 
time, /dev/sdd4 failed, resulting in a superblock update on sda4, sdb4, 
and sdc4.  From the looks of it, the update landed on sda4 before 
something else happened causing the raid subsystem to mark sda4 as bad. 
  Then, we marked sda4 bad in our internal superblock and wrote that to 
sdb4, and then that must have returned a failure before we even 
attempted to write sdc4 and we marked sdb4 bad before we did.

This is what I think normally happens when we have a drive fail, but the 
rest of the system is ok:

drive X fails ->
   update event count and mark drive bad in superblock ->
     submit write to new superblock on drive A
     submit write to new superblock on drive B
     submit write to new superblock on drive C
     (delay for drive access time)
     write to new superblock on drive A completes
     write to new superblock on drive B completes
     write to new superblock on drive C completes
   superblock update complete, array in consistent, degraded state

Now, here's where I think the problem may creep in:

drive X fails ->
   update event count and mark drive bad in superblock ->
     submit write to new superblock on drive A
       write to drive A immediately fails, mark drive A bad in superblock
       but because we are in the process of doing a superblock update
       with a new event count, don't bother to increment event count
     submit write to new superblock on drive B with drive A marked bad ->
       write to drive B immediately fails, mark drive B bad in superblock
       but because we are in the process of doing a superblock update
       with a new event count, don't bother to increment event count
     submit write to new superblock on drive C, ditto on the rest
   superblock update more or less fails, but for some reason, the writes
   actually completed to disk (an interrupt issue on the
   controller would cause the write to complete but never get
   acknowledged by the disk layer, resulting in the sort of thing we see
   here, although that wouldn't explain the ordering)

I haven't actually read through the code, but this is the sort of thing 
that seems to be happening.  I don't have a better explanation for why 
the superblocks got into the state that they are.

Now, as for what to do, I think the only thing to do now is to recreate 
the array using the same information that you currently have.

Use the output of mdadm -E on a constituent device to get all the 
settings you need (save them off).  Then you should be able to get the 
superblock version, the chunk size, the presence or absence of a bitmap, 
bitmap chunk, and the data offset from the mdadm -E output you saved. 
As long as any attempts to remake the array use the same superblock 
version, use --assume-clean, keep the drives in the right order, and the 
array is created/assembled in read-only state and you just do a 
read-only fsck, then you won't corrupt anything in the array if the rest 
of the parameters aren't perfect and you can try again as many times as 
needed to get things right and get the disks back online.  The one thing 
you might have to do is track down the same version of mdadm that was 
used to create the array as the default data offset for some of the 
superblock versions has changed over time and you might not be able to 
get the data offset right without having the older mdadm version on hand.

> At this point we found only the two options I mentioned, and we
> decided to climb the mountain and talk to the oracle. Is there another
> way to get the other two drives back into the array?
>
> regards,
>
> Kevin
>
> On 5 November 2013 00:28, Phil Turmel <philip@turmel.org> wrote:
>> Hi Kevin,
>>
>> On 11/04/2013 08:51 AM, Kevin Wilson wrote:
>>> Good day All,
>>
>> [snip /]
>>
>> Good report, BTW.
>>
>>> 1. Hexedit the drive status information in the superblocks and set it
>>> to what we require to assemble
>>
>> You would have to be very brave to try that, and very confident that you
>> complete understood the on-disk raid metadata.
>>
>>> 2. Run the create option of mdadm with precisely the original
>>> configuration of the pack to overwrite the superblock information
>>
>> This is a valid option, but should always be the *last* resort.
>>
>> Your research missed the recommended *first* option:
>>
>> mdadm --assemble --force ....
>>
>> [snip /]
>>
>>> Mdadm examine for each drive:
>>> /dev/sda4:
>>
>>>           Events : 18538
>>>     Device Role : Active device 0
>>>     Array State : AAA. ('A' == active, '.' == missing)
>>
>>> /dev/sdb4:
>>>           Events : 18538
>>>     Device Role : Active device 1
>>>     Array State : .AA. ('A' == active, '.' == missing)
>>
>>> /dev/sdc4:
>>>           Events : 18538
>>>     Device Role : Active device 2
>>>     Array State : ..A. ('A' == active, '.' == missing)
>>
>>> /dev/sdd4 is the faulty drive that now shows up as 4GB.
>>
>> Check /proc/mdstat and then use mdadm --stop to make sure any partial
>> assembly of these devices is gone.  Then
>>
>> mdadm -Afv /dev/md3 /dev/sd[abc]4
>>
>> Save the output so you can report it to this list if it fails.  You
>> should end up with the array running in degraded mode.
>>
>> Use fsck as needed to deal with the detritus from the power losses, then
>> make your backups.
>>
>> HTH,
>>
>> Phil
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

