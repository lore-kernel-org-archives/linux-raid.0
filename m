From: LinuxRaid@Suykerbuyk.org
Subject: Re: Joys of spare disks!
Date: Mon, 7 Mar 2005 12:15:42 -0800 (PST)
Message-ID: <200503072015.j27KFgvL048187@newsguy.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, 

With this much interest, I will tear back into the bowels of Raid-5. Again,
anyone else reading this with a shred of a clue as to where to start, please
chime in!

- John "S"

At Mon, 07 Mar 2005 10:18:14 -0800, you wrote
>
>
>
>LinuxRaid@Suykerbuyk.org wrote:
>
>> I'm running several RAID-5 arrays against mixed PATA/SATA systems, and I am
>>amazed at how fragile Linux Software RAID-5 really is.  It makes no sense to
>
>Amen!
>
>> What should be happening:
>> 1) Drive has a read error or does not deliver the data within the command
>> timeout parameters that have been issued to the drive.
>> 2) RAID driver collects the blocks from the "working" drives, generates the
>> missing data from the problem drive.
>> 3) RAID driver both returns the data to the calling process, and issues a
>> re-write of the bad block on the disk drive in question.
>> 4) RAID drive generates a log message tracking the problem
>>5) When the number of "event messages" for block re-writes exceeds a certain
>> threshold, alert the sys-admin that a specific drive is unreliable.
>
>Absolutely
>
>>impliment this.  I'm not a Linux / kernel hacker (yet), but this should not be
>> hard to fix....
>
>You will have a very willing tester in me if you generate any patches. I 
>haven't played with device mapper yet (though that is apparently the way 
>to get fake "faulty" devices for testing), but I have created a quick 
>script to create/destroy a loopback-mounted set of files and raid5 array 
>on top of it. Its in the archives and may or may not help as a test rig 
>as you're hacking on the code
>
>There's lots more people than just me interested too, if you've got the 
>motivation
>
>-Mike
>

