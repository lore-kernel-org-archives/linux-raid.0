From: Tejas Rao <raot@bnl.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 20:36:08 -0500
Message-ID: <5678A908.6070401@bnl.gov>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov> <8737uv4fz6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737uv4fz6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org, "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

Each GPFS disk (block device) has a list of servers associated with it. 
When the first storage server fails (expired disk lease), the storage 
node is expelled and a different server which also sees the shared 
storage will do I/O.

There is a "leaseRecoveryWait" parameter which tells the filesystem 
manager to wait for few seconds to allow the expelled node to complete 
any I/O in flight to the shared storage device to avoid any out of order 
i/O. After this wait time, the filesystem manager completes recovery on 
the failed node, replaying journal logs, freeing up shared tokens/locks 
etc. After the recovery is complete a different storage node will do 
I/O. There is a concept of primary/secondary servers for a given block 
device. The secondary server will only do I/O when the primary server 
has failed and this has been confirmed.

See "servers=ServerList" in man page for mmcrnsd. ( I don't think I am 
allowed to send web links)

We currently have 10's of petabytes in production using linux md raid. 
We are currently not sharing md devices, only hardware raid block 
devices are shared. In our experience hardware raid controllers are 
expensive. Linux raid has worked well over the years and performance is 
very good as GPFS coalesces I/O in large filesystem blocksize blocks 
(8MB) and if aligned properly eliminate RMW (doing full stripe writes) 
and the need for NVRAM (unless someone is doing POSIX fsync).

In the future ,we would prefer to use linux raid (RAID6) in a shared 
environment shielding us against server failures. Unfortunately we can 
only do this after Redhat supports such an environment with linux raid. 
Currently they do not support this even in an active/passive environment 
(only one server can have a md device assembled and active regardless).

Tejas.

On 12/21/2015 17:03, NeilBrown wrote:
> On Tue, Dec 22 2015, Tejas Rao wrote:
>
>> GPFS guarantees that only one node will write to a linux block device
>> using disk leases.
>
> Do you have a reference to documentation explaining that?
> A few moments searching the internet suggests that a "disk lease" is
> much like a heart-beat.  A node uses it to say "I'm still alive, please
> don't ignore me".  I could find no evidence that only one node could
> hold a disk lease at any time.
>
> NeilBrown
>
>
>>                     Only a node with a disk lease has the right to submit
>> I/O and disk leases expire every 30 secs and needs to be renewed. Lustre
>> and other distributed file systems have other ways of handing this.
>>
>> Using md devices in a shared/clustered environment is something not
>> supported by Redhat on RHEL6 or RHEL7 kernels, so this is something we
>> would not try in our production environments.
>>
>> Tejas.
>>
>> On 12/21/2015 15:47, NeilBrown wrote:
>>> On Tue, Dec 22 2015, Tejas Rao wrote:
>>>
>>>> What if the application is doing the locking and making sure that only 1
>>>> node writes to a md device at a time? Will this work? How are rebuilds
>>>> handled? This would be helpful with distributed filesystems like
>>>> GPFS/lustre etc.
>>>>
>>> You would also need to make sure that the filesystem only wrote from a
>>> single node at a time (or access the block device directly).  I doubt
>>> GPFS/lustre make any promise like that, but I'm happy to be educated.
>>>
>>> rebuilds are handled by using a cluster-wide lock to block all writes to
>>> a range of addresses while those stripes are repaired.
>>>
>>> NeilBrown
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

