From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Fri, 10 May 2013 23:35:31 +0200
Message-ID: <518D6823.2010003@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/26/2013 05:53 PM, Robin Hill wrote:
> On Fri Apr 26, 2013 at 04:27:01PM +0200, Roberto Nunnari wrote:
>
>> Hi all.
>>
>> I'd like to replace two hd in raid1 with larger ones.
>>
>> I could just add the new drives in raid1 and mount it on /opt after a
>> dump/restore, but I'd prefer to just have to drives instead of four..
>> less noise and less power consumption and noise.
>>
>> The question is: what whould be the best way to go?
>> Tricks and tips? Drawbacks? Common errors?
>>
>> Any hint/advice welcome.
>> Thank you. :-)
>>
>>
>> present HD: two WD caviar green 500GB
>> new HD: two WD caviar green 2TB
>>
> I don't think these have SCTERC configuration options, so you'll need to
> make sure you increase the timeout in the storage stack to prevent read
> timeouts from causing drives to be prematurely kicked out of the array.
>
>>
>> root@host1:~# uname -rms
>> Linux 2.6.32-46-server x86_64
>>
> That'll be too old for the hot-replacement functionality, but that
> doesn't make much difference for RAID1 anyway.
>
>> root@host1:~# cat /proc/mdstat
>> Personalities : [linear] [raid1] [multipath] [raid0] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : active raid1 sda2[0] sdb2[1]
>>         7812032 blocks [2/2] [UU]
>>
>> md2 : active raid1 sda3[0] sdb3[1]
>>         431744960 blocks [2/2] [UU]
>>
>> md0 : active raid1 sda1[0] sdb1[1]
>>         48827328 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
> The safest option would be:
>   - add in the new disks
>   - partition to at least the same size as your existing partitions (they
>     can be larger)
>   - add the new partitions into the arrays (they'll go in as spares)
>   - grow the arrays to 4 members (this avoids any loss of redundancy)
>   - wait for the resync to complete
>   - install grub/lilo/syslinux to the new disks
>   - fail and remove the old disk partitions from the arrays
>   - shrink the arrays back down to 2 members
>   - remove the old disks
>
> Then, if you're keeping the same number of partitions but increasing the
> size:
>   - grow the arrays to fill the partitions
>   - grow the filesystems to fill the arrays
> or, if you're adding extra partitions:
>   - create new arrays on extra partitions
>   - format and mount
>
> If you have hot-plug bays then you can do all this without any downtime
> (you could also do one disk at a time and just grow the arrays to 3
> members), otherwise you'll need to shut down to install and remove the
> disks.  If you only have two bays then you could fail one of the disks
> then recover to a new one, but that's definitely a risky option.
>
> That's the outline of the process anyway - if you need any details of
> the actual commands then do ask.
>
> HTH,
>      Robin
>

Done!

linux-raid is GREAT!! I was worried.. but it all went very smooth and my 
system is up and running with very little downtime! mdadm is very 
flexible and powerful!

Thank you Robin for your support!
Best regards.
Robi
