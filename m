From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 16:38:04 +0000
Message-ID: <582C8B6C.5040303@youngman.org.uk>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
 <582C7CC3.40901@youngman.org.uk>
 <275e84b8-4a2c-5ef2-0e88-5dfe28e42fc9@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <275e84b8-4a2c-5ef2-0e88-5dfe28e42fc9@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids

On 16/11/16 15:50, Alexander Shenkin wrote:
> 
> 
> On 11/16/2016 3:35 PM, Wols Lists wrote:
>> On 16/11/16 09:04, Alexander Shenkin wrote:
>>> Hello all,
>>>
>>> As a quick reminder, my sdb failed in a 4-disk RAID5, and then sdc
>>> failed when trying to replace sdb.  I'm now trying to recover sdc with
>>> ddrescue.
>>>
>>> After much back and forth, I've finally got ddrescue running to
>>> replicate my apparently-faulty sdc.  I'm ddrescue'ing from a seagate 3TB
>>> to a toshiba 3TB drive, and I'm getting a 'No space left on device
>>> error'.  Any thoughts?
>>>
>>> One further question: should I also try to ddrescue my original failed
>>> sdb in the hopes that anything lost on sdc would be covered by the
>>> recovered sdb?
>>
>> Depends how badly out of sync the event counts are. However, I note that
>> your ddrescue copy appeared to run without any errors (apart from
>> falling off the end of the drive :-) ?
> 
> Thanks Wol.
> 
> From my newbie reading, it looked like there was on 65kb error... but
> i'm not sure how to tell if it got read properly by ddrescue in the end
> - any tips?  I don't see any "retrying bad sectors" (-) lines in the
> logfile below...
> 
> username@Ubuntu-VirtualBox:~$ sudo ddrescue -d -f -r3 /dev/sdb /dev/sdc
> ~/rescue.logfile
> [sudo] password for username:
> GNU ddrescue 1.19
> Press Ctrl-C to interrupt
> rescued:     3000 GB,  errsize:   65536 B,  current rate:   55640 kB/s
>    ipos:     3000 GB,   errors:       1,    average rate:   83070 kB/s
>    opos:     3000 GB, run time:   10.03 h,  successful read:       0 s ago
> Copying non-tried blocks... Pass 1 (forwards)
> ddrescue: Write error: No space left on device
> 
> # Rescue Logfile. Created by GNU ddrescue version 1.19
> # Command line: ddrescue -d -f -r3 /dev/sdb /dev/sdc
> /home/username/rescue.logfile
> # Start time:   2016-11-15 13:54:24
> # Current time: 2016-11-15 23:56:25
> # Copying non-tried blocks... Pass 1 (forwards)
> # current_pos  current_status
> 0x2BAA1470000     ?
> #      pos        size  status
> 0x00000000  0x7F5A0000  +
> 0x7F5A0000  0x00010000  *
> 0x7F5B0000  0x00010000  ?
> 0x7F5C0000  0x2BA21EB0000  +
> 0x2BAA1470000  0x00006000  ?
> 
>>
>> In which case, you haven't lost anything on sdc. Which is why the wiki
>> says don't mount your array writeable while you're trying to recover it
>> - you're not going to muck up your data and have user-space provoke
>> further errors.
> 
> gotcha - i'm doing this with removed drives on a different (virtual)
> machine.  Seemed like the arrays were getting mounted read-only by
> default when the disks were having issues...
> 
>>
>> If the array barfs while it's rebuilding, it's hopefully just a
>> transient, and do another assemble with --force to get it back again.
> 
> so, i guess i put the copied drive back in as sdc, and a new blank drive
> as sdb, add sdb, and just let it rebuild from there?  Or, do I issue
> this command as appropriate?
> 
> mdadm --force --assemble /dev/mdN /dev/sd[XYZ]1

Let me get my thoughts straight - cross check what I'm writing but ...

sda and sdd have never failed. sdc is the new drive you've ddrescue'd onto.

So in order to get a working array, you need to do
"mdadm --assemble /dev/sd[adc]n"
This will give you a working, degraded array, which unfortunately
probably has a little bit of corruption - whatever you were writing when
the array first failed will not have been saved properly. You've
basically recovered the array with the two drives that are okay, and a
copy of the drive that failed most recently.

IFF the smarts report that your two failed drives are okay, then you can
add them back in. I'm hoping it was just the timeout problem - with
Barracudas that's quite likely.

MAKE SURE that you've run the timeout script on all the Barracudas, or
the array is simply going to crash again.

WIPE THE SUPERBLOCKS on the old drives. I'm not sure what the mdadm
command is, but we're adding them back in as new drives.

mdadm --add /dev/old-b /dev/old-c

This will think they are two new drives and will rebuild on to one of
them. You can then convert the array to raid 6 and it will rebuild on to
the other one.

Once you've got back to a fully-working raid-5, you can do a fsck on the
filesystem(s) to find the corruption.

Lastly, if you can get another Toshiba drive, add that in as a spare.

This will leave you with a 6-drive raid-6 - 3xdata, 2xparity, 1xspare.

If the smarts report that any of your barracudas have a load of errors,
it's not worth faffing about with them. Bin them and replace them.

Going back to an earlier point of yours - DO NOT try to force re-add the
first drive that failed back into the array. The mismatch in event count
will mean loads of corruption.

Cheers,
Wol
> 
>>
>> Once you've got the array properly back up again :-
>>
>> 1) make sure that the timeout script is run EVERY BOOT to fix the kernel
>> defaults for your remaining barracudas.
>>
>> 2) make sure smarts are enabled EVERY BOOT because barracudas forget
>> their settings on power-off.
>>
>> 3) You've now got a spare drive. If a smart self-check comes back pretty
>> clean and it looks like a transient problem not a dud drive, then put it
>> back in and convert the array to raid 6.
>>
>> 4) MONITOR MONITOR MONITOR
>>
>> You've seen the comments elsewhere about the 3TB barracudas? Barracudas
>> in general aren't bad drives, but the 3TB model has a reputation for
>> dying early and quickly. You can then plan to replace the drives at your
>> leisure, knowing that provided you catch any failure, you've still got
>> redundancy with one dead drive in a raid-6. Even better, get another
>> Toshiba and go raid-6+spare. And don't say you haven't got enough sata
>> ports - an add-in card is about £20 :-)
>>
>> Cheers,
>> Wol
>>
> 

