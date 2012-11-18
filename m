From: Martijn <mailinglist@mindconnect.nl>
Subject: Re: RAID1 performance and "task X blocked for more than 120 seconds"
Date: Sun, 18 Nov 2012 22:53:18 +0100
Message-ID: <50A958CE.5030902@mindconnect.nl>
References: <50A92B52.7030905@mindconnect.nl> <50A94D9F.3060601@hardwarefreak.com>
Reply-To: mailinglist@mindconnect.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A94D9F.3060601@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stan@hardwarefreak.com
List-Id: linux-raid.ids

Thank you for your response Stan.

On 18-11-2012 22:05, Stan Hoeppner wrote:
> On 11/18/2012 12:39 PM, Martijn wrote:
>> - Disks are all Seagate Barracuda 7200.12 ST31000528AS, 1TB.
>> - NCQ is disabled by setting queue_depth to 1.
> WRT write throughput, you have effectively a single 7.2k spindle.  The
> only way to get lower performance is a 5xxx RPM 'green' or laptop drive.
>   This is a low performance machine.
It's certainly not a top notch performance machine and I know that. It's 
old hardware. The disks are the newest component. For the record: no 
great performance is needed. I only expect the machine the behave 
normally under normal ("copying a few files") circumstances.

For comparison:
I've (had) more of these machines, working well, with mdadm RAID1 on 
much lower performance disks. Same motherboard. Same (deadline) 
scheduler. A difference is they don't use a partitionable device, but 
seperate partitions in RAID1, so /dev/sda1 mirroring /dev/sdb1, and so 
on. Also, a different OS: an older version of Gentoo.

They never had any trouble keeping up and certainly never had an entry 
in the syslog like the one I got now. Actually I just tried copying that 
same 3 GB of files, and it worked flawlessly. No hickups and without 
starving the machine. That is even while it's in production, under some 
load.

%iowait on that machine is around 30% while copying. When the copy is 
done, writing very quickly returns to 0 blocks/s normal on that machine.

>> The problem:
>> I was copying 3 GB of data using rsync, from another server to this
>> machine over a 100 mbit connection. After some time it appeared to me as
>> if one of the two systems was having trouble keeping up. Copying speed
>> was a few MB/s and the transfer sometimes stopped for a longer period of
>> time, then to continue again.
>>
>> Looking at the receiving system, I noticed this in syslog:
>> task kjournald blocked for more than 120 seconds
>> task dkpg-preconfigure blocked for more than 120 seconds
>> [...]
>>
>> dpkg-preconfigure being a process running at that time.
>
> Multiple disk intensive processes running concurrently.
The dkpg-preconfigure was a coincidence. It wasn't running when I did 
the local copy. The syslog entries then mentioned a few vim editors I 
had open to edit config files.

>> Eventually, the copy completed. But some time after the copy was
>> completed, I still noticed a high (50-80%) %iowait and 2000 to 4000
>> blocks being written to sda and sdb. I monitored this using iostat.
>
> This is the buffer cache flushing.
>
>> I waited for the system to return to 0 writes and a load of near 0 when
>> I attempted to copy the data on disk from directory A to B, and the same
>> problem occured.
>
> Your previously mentioned symptoms were leading me to this, but this one
> kinda seals the deal.  This sounds like classic filesystem free space
> fragmentation.  What filesystem is this?  The 3GB of files--are they
> large or small files?

Except for /boot, it's all ext3. Free space:
Filesystem            Size  Used Avail Use% Mounted on
/dev/md127p2           60G  1.1G   56G   2% /
/dev/md127p6          7.9G  149M  7.4G   2% /tmp
/dev/md127p1          243M   19M  212M   9% /boot
/dev/md127p3          709G  6.5G  667G   1% /home
/dev/md127p5          119G  420M  112G   1% /var

Less than 10% usage on every partition. The filesystems have always been 
empty. This data was amongst the very first data written to the /home. 
All partitions where created using standard Linux fdisk and then 
formatted using mkfs.ext3.

The 3GB consists of very mixed content: mostly small files (~1KB), and 
just a few bigger (50MB+).

Thanks,
- Martijn
