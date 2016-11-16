From: Alexander Shenkin <al@shenkin.org>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 15:50:34 +0000
Message-ID: <275e84b8-4a2c-5ef2-0e88-5dfe28e42fc9@shenkin.org>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
 <582C7CC3.40901@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <582C7CC3.40901@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids



On 11/16/2016 3:35 PM, Wols Lists wrote:
> On 16/11/16 09:04, Alexander Shenkin wrote:
>> Hello all,
>>
>> As a quick reminder, my sdb failed in a 4-disk RAID5, and then sdc
>> failed when trying to replace sdb.  I'm now trying to recover sdc with
>> ddrescue.
>>
>> After much back and forth, I've finally got ddrescue running to
>> replicate my apparently-faulty sdc.  I'm ddrescue'ing from a seagate 3TB
>> to a toshiba 3TB drive, and I'm getting a 'No space left on device
>> error'.  Any thoughts?
>>
>> One further question: should I also try to ddrescue my original failed
>> sdb in the hopes that anything lost on sdc would be covered by the
>> recovered sdb?
>
> Depends how badly out of sync the event counts are. However, I note that
> your ddrescue copy appeared to run without any errors (apart from
> falling off the end of the drive :-) ?

Thanks Wol.

 From my newbie reading, it looked like there was on 65kb error... but 
i'm not sure how to tell if it got read properly by ddrescue in the end 
- any tips?  I don't see any "retrying bad sectors" (-) lines in the 
logfile below...

username@Ubuntu-VirtualBox:~$ sudo ddrescue -d -f -r3 /dev/sdb /dev/sdc 
~/rescue.logfile
[sudo] password for username:
GNU ddrescue 1.19
Press Ctrl-C to interrupt
rescued:     3000 GB,  errsize:   65536 B,  current rate:   55640 kB/s
    ipos:     3000 GB,   errors:       1,    average rate:   83070 kB/s
    opos:     3000 GB, run time:   10.03 h,  successful read:       0 s ago
Copying non-tried blocks... Pass 1 (forwards)
ddrescue: Write error: No space left on device

# Rescue Logfile. Created by GNU ddrescue version 1.19
# Command line: ddrescue -d -f -r3 /dev/sdb /dev/sdc 
/home/username/rescue.logfile
# Start time:   2016-11-15 13:54:24
# Current time: 2016-11-15 23:56:25
# Copying non-tried blocks... Pass 1 (forwards)
# current_pos  current_status
0x2BAA1470000     ?
#      pos        size  status
0x00000000  0x7F5A0000  +
0x7F5A0000  0x00010000  *
0x7F5B0000  0x00010000  ?
0x7F5C0000  0x2BA21EB0000  +
0x2BAA1470000  0x00006000  ?

>
> In which case, you haven't lost anything on sdc. Which is why the wiki
> says don't mount your array writeable while you're trying to recover it
> - you're not going to muck up your data and have user-space provoke
> further errors.

gotcha - i'm doing this with removed drives on a different (virtual) 
machine.  Seemed like the arrays were getting mounted read-only by 
default when the disks were having issues...

>
> If the array barfs while it's rebuilding, it's hopefully just a
> transient, and do another assemble with --force to get it back again.

so, i guess i put the copied drive back in as sdc, and a new blank drive 
as sdb, add sdb, and just let it rebuild from there?  Or, do I issue 
this command as appropriate?

mdadm --force --assemble /dev/mdN /dev/sd[XYZ]1

>
> Once you've got the array properly back up again :-
>
> 1) make sure that the timeout script is run EVERY BOOT to fix the kernel
> defaults for your remaining barracudas.
>
> 2) make sure smarts are enabled EVERY BOOT because barracudas forget
> their settings on power-off.
>
> 3) You've now got a spare drive. If a smart self-check comes back pretty
> clean and it looks like a transient problem not a dud drive, then put it
> back in and convert the array to raid 6.
>
> 4) MONITOR MONITOR MONITOR
>
> You've seen the comments elsewhere about the 3TB barracudas? Barracudas
> in general aren't bad drives, but the 3TB model has a reputation for
> dying early and quickly. You can then plan to replace the drives at your
> leisure, knowing that provided you catch any failure, you've still got
> redundancy with one dead drive in a raid-6. Even better, get another
> Toshiba and go raid-6+spare. And don't say you haven't got enough sata
> ports - an add-in card is about £20 :-)
>
> Cheers,
> Wol
>
