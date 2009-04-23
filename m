From: John Hughes <john@Calva.COM>
Subject: Re: Using linux software raid (mdadm) in a shared-disk cluster.
Date: Thu, 23 Apr 2009 11:22:25 +0200
Message-ID: <49F03351.3090301@Calva.COM>
References: <49E45044.5000406@Calva.COM> <87prf5m5kt.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87prf5m5kt.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> John Hughes <john@Calva.COM> writes:
>   
>> I've got a little shared disk cluster (parallel SCSI, external DELL
>> PV210 disk cabinet).
>>
>> I've used linux raid to make a nice RAID10 on the external disks.
>>
>> I can access this from either machine in the cluster, only one at a
>> time of course, it works very well and I'm happy.
>>
>> Now I'm running XEN and I want to be able to migrate a XEN domU from
>> one machine to the other while the domU is using the RAID10 device.  I
>> can make this "work" using XEN's migration hooks - it calls a script
>> when it has stopped the running domU and I can start the raid device
>> on the destination node, ready for the arrival of the domU.
>>
>> There is one small problem - I can't stop the RAID10 on the source
>> node until the domU has finished, so it seems to me there is a window
>> that could lead to data corruption:
>>     
>
> Can you put it into read-only mode?
>   

How do I do that?

Ah, by "mdadm --readonly"[*].

> I'm not even sure putting a raid in read-only mode will stop
> background syncing.
>   

Hang on a sec, I'll try it.

... run bonnie on mounted /dev/md0, kill it, umount the device ...

# cat /proc/mstat
Personalities : [raid10] 
md0 : active raid10 sda3[0] sde2[4](S) sdd3[3] sdc3[2] sdb3[1]
      32067456 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 66/123 pages [264KB], 128KB chunk

# mdadm --readonly /dev/md0
# cat /proc/mdstat 
Personalities : [raid10] 
md0 : active (read-only) raid10 sda3[0] sde2[4](S) sdd3[3] sdc3[2] sdb3[1]
      32067456 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 66/123 pages [264KB], 128KB chunk

... wait a bit
# cat /proc/mdstat
Personalities : [raid10] 
md0 : active (read-only) raid10 sda3[0] sde2[4](S) sdd3[3] sdc3[2] sdb3[1]
      32067456 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/123 pages [0KB], 128KB chunk

No, it seems to keep on syncing.  Bummer.

> As an alternative approach how about running the raid10 inside the
> domU?
>   

Didn't want to do that as it requires exporting loadsa devices to the 
domU instead of one.

But maybe it's the only way (without hacking the md code).
