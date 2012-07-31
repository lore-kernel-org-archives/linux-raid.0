From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Version 3.2.5 and ddf issues (bugreport)
Date: Tue, 31 Jul 2012 10:46:26 +0200
Message-ID: <50179B62.9020603@gmail.com>
References: <4D8A4780.2030401@gmail.com> <20110324090837.689c5a0e@notabene.brown> <5013D0FE.3020906@gmail.com> <20120731161115.46b96f90@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120731161115.46b96f90@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/31/2012 08:11 AM, NeilBrown wrote:
> On Sat, 28 Jul 2012 13:46:06 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:
>
>> Hi Neil,
>>
>> After a hiatus of 1.5 year (busy with all sorts) I am back and tried the
>> ddf code to see how things improved.
> Thanks!
>
>> I build a VM Centos 6.3 system with 6 extra 1GB disks for testing.
>> I found several issues in the standard installed 3.2.3 version of mdadm
>> relating to ddf, but installed the
>> 3.2.5 version in order to work with recent code.
>>
>> However, while version 3.2.3 is able to create a ddf container with
>> raidsets in it, I found a problem with the 3.2.5 version.
>>
>> After initially creating the container:
>>
>> mdadm -C /dev/md127 -e ddf -l container /dev/sd[b-g]
>>
>> which worked, I created a raid (1 or 5 it doesn't matter in this case)
>> in it:
>>
>> mdadm -C /dev/md0 -l raid5 -n 3 /dev/md127
>>
>> However, it stays on resync=PENDING and readonly, and doesn't get build.
>>
>> So I tried to set it to readwrite:
>>
>> mdadm --readwrite  /dev/md0
>>
>> Unfortunately, it stays on readonly and doesn't get build.
>>
>> As said before, this did work in 3.2.3.
>>
>> Are you already on this problem?
> It sounds like a problem with 'mdmon'.  mdmon needs to be running before the
> array can become read-write.  mdadm should start mdmon automatically but
> maybe it isn't.  Maybe it cannot find mdmon?
>
> could you check if mdadm is running?  If it isn't run
>     mdmon /dev/md127 &
> and see if it starts working.
Hi Neil,

thanks for your reply. Yes, mdmon wasn't running. Couldn't get it 
running with a recompiled 3.2.5, the standard one which came with Centos 
(3.2.3) works fine, I assume the made some changes to the code? Anyway, 
I moved to my own laptop, running Fedora 16 and pulled mdadm frm git and 
recompiled. That works. I also used loop devices as disks.

Here is the first of my findings:

I created a container with six disks, disk 1-2 is a raid 1 device, disk 
3-6 are a raid 6 device.

Here is the table shown at the end of the mdadm -E command for the 
container:

  Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    06a5f547    479232K /dev/loop2      active/Online
          1    47564acc    479232K /dev/loop3      active/Online
          2    bf30692c    479232K /dev/loop5      active/Online
          3    275d02f5    479232K /dev/loop4      active/Online
          4    b0916b3f    479232K /dev/loop6      active/Online
          5    65956a72    479232K /dev/loop1      active/Online

I now fail a disk (disk 0) and I get:

  Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    06a5f547    479232K /dev/loop2      active/Online
          1    47564acc    479232K /dev/loop3      active/Online
          2    bf30692c    479232K /dev/loop5      active/Online
          3    275d02f5    479232K /dev/loop4      active/Online
          4    b0916b3f    479232K /dev/loop6      active/Online
          5    65956a72    479232K /dev/loop1      active/Offline, Failed

Then I removed the disk from the container:

  Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    06a5f547    479232K /dev/loop2      active/Online
          1    47564acc    479232K /dev/loop3      active/Online
          2    bf30692c    479232K /dev/loop5      active/Online
          3    275d02f5    479232K /dev/loop4      active/Online
          4    b0916b3f    479232K /dev/loop6      active/Online
          5    65956a72    479232K                 active/Offline, 
Failed, Missing

Notice the active/Offline status, is this correct?

I added the disk back into the container, NO zero-superblock:

  Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    06a5f547    479232K /dev/loop2      active/Online
          1    47564acc    479232K /dev/loop3      active/Online
          2    bf30692c    479232K /dev/loop5      active/Online
          3    275d02f5    479232K /dev/loop4      active/Online
          4    b0916b3f    479232K /dev/loop6      active/Online
          5    65956a72    479232K /dev/loop1      active/Offline, 
Failed, Missing

It stays active/Offline (this is now correct I assume), Failed (again 
correct if had failed before), but also still missing.

I remove the disk again, do a zero-superblock and add it again:

Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    06a5f547    479232K /dev/loop2      active/Online
          1    47564acc    479232K /dev/loop3      active/Online
          2    bf30692c    479232K /dev/loop5      active/Online
          3    275d02f5    479232K /dev/loop4      active/Online
          4    b0916b3f    479232K /dev/loop6      active/Online
          5    ede51ba3    479232K /dev/loop1      active/Online, Rebuilding

This is correct, the disk is seen as a new disk and rebuilding starts.


Regards,

Albert
