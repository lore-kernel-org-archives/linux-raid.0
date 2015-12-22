From: Tejas Rao <raot@bnl.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 21:33:55 -0500
Message-ID: <5678B693.40907@bnl.gov>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov> <8737uv4fz6.fsf@notabene.neil.brown.name> <5678A2B9.6070008@bnl.gov> <5678AC55.7070606@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5678AC55.7070606@nasa.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Knister <aaron.s.knister@nasa.gov>
Cc: NeilBrown <neilb@suse.de>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/21/2015 20:50, Aaron Knister wrote:
> Hi Tejas et al,
>
> I'm fairly confident in saying that GPFS can have many servers actively
> writing to a given NSD (LUN) at any given time. In our production
> environment the NSDs have 6 servers defined and clients more or less
> write to whichever one their little hearts desire. Do you think it's
> possible that the explicit primary/secondary concept is from an older
> version of GPFS? I'm not sure what the locking granularity is for
> NSDs/disks, but even if it's a single GPFS FS block and that block size
> corresponds to the stripe width of the array I'm pretty nervous relying
> on that assumption for data integrity :)
>
> The use case here is creating effectively highly available block storage
> from shared JBODs for use by VMs on the servers as well as to be
> exported to other nodes. The filesystem we're using for this is actually
> GPFS. The intent was to use RAID6 in an active/active fashion on two
> nodes sharing a common set of disks. The active/active was in an effort
> to simplify the configuration.

You are probably not defining the NSD parameter "servers=ServerList". If 
this parameter is not defined, GPFS assumes that the disks are SAN 
attached to all the NSD nodes, in this case there is no 
primary/secondary server. Of-course there is no risk of data integrity 
even if the "servers" parameter is not defined.
>
> I'm curious now, Redhat doesn't support SW raid failover? I did some
> googling and found this:
>
> https://access.redhat.com/solutions/231643
>
> While I can't read the solution I have to figure that they're now
> supporting that. I might actually explore that for this project.
https://access.redhat.com/solutions/410203
This article states that md raid is not supported in RHEL6/7 under any 
circumstances, including active/passive modes.
>
> -Aaron
>
> On 12/21/15 8:09 PM, Tejas Rao wrote:
>> Each GPFS disk (block device) has a list of servers associated with it.
>> When the first storage server fails (expired disk lease), the storage
>> node is expelled and a different server which also sees the shared
>> storage will do I/O.
>>
>> There is a "leaseRecoveryWait" parameter which tells the filesystem
>> manager to wait for few seconds to allow the expelled node to complete
>> any I/O in flight to the shared storage device to avoid any out of order
>> i/O. After this wait time, the filesystem manager completes recovery on
>> the failed node, replaying journal logs, freeing up shared tokens/locks
>> etc. After the recovery is complete a different storage node will do
>> I/O. There is a concept of primary/secondary servers for a given block
>> device. The secondary server will only do I/O when the primary server
>> has failed and this has been confirmed.
>>
>> See "servers=ServerList" in man page for mmcrnsd. ( I don't think I am
>> allowed to send web links)
>>
>> We currently have 10's of petabytes in production using linux md raid.
>> We are currently not sharing md devices, only hardware raid block
>> devices are shared. In our experience hardware raid controllers are
>> expensive. Linux raid has worked well over the years and performance is
>> very good as GPFS coalesces I/O in large filesystem blocksize blocks
>> (8MB) and if aligned properly eliminate RMW (doing full stripe writes)
>> and the need for NVRAM (unless someone is doing POSIX fsync).
>>
>> In the future ,we would prefer to use linux raid (RAID6) in a shared
>> environment shielding us against server failures. Unfortunately we can
>> only do this after Redhat supports such an environment with linux raid.
>> Currently they do not support this even in an active/passive environment
>> (only one server can have a md device assembled and active regardless).
>>
>> Tejas.
>>
>> On 12/21/2015 17:03, NeilBrown wrote:
>> > On Tue, Dec 22 2015, Tejas Rao wrote:
>> >
>> >> GPFS guarantees that only one node will write to a linux block device
>> >> using disk leases.
>> >
>> > Do you have a reference to documentation explaining that?
>> > A few moments searching the internet suggests that a "disk lease" is
>> > much like a heart-beat. A node uses it to say "I'm still alive, please
>> > don't ignore me". I could find no evidence that only one node could
>> > hold a disk lease at any time.
>> >
>> > NeilBrown
>>
>

