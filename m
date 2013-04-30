From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 15:17:30 +0200
Message-ID: <517FC46A.1080702@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
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

How do I increase that timeout?

Also, the old HD are up and running for over 4 years now, and never got 
any trouble.. just time to time a few warning on /dev/sdb from smartctl:

Device: /dev/sdb, ATA error count increased from 27 to 28

But I don't believe that's something to worry about..


> 
>> root@host1:~# uname -rms
>> Linux 2.6.32-46-server x86_64
>>
> That'll be too old for the hot-replacement functionality, but that
> doesn't make much difference for RAID1 anyway.

ok.


> 
>> root@host1:~# cat /proc/mdstat
>> Personalities : [linear] [raid1] [multipath] [raid0] [raid6] [raid5] 
>> [raid4] [raid10]
>> md1 : active raid1 sda2[0] sdb2[1]
>>        7812032 blocks [2/2] [UU]
>>
>> md2 : active raid1 sda3[0] sdb3[1]
>>        431744960 blocks [2/2] [UU]
>>
>> md0 : active raid1 sda1[0] sdb1[1]
>>        48827328 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
> The safest option would be:
>  - add in the new disks
>  - partition to at least the same size as your existing partitions (they
>    can be larger)
>  - add the new partitions into the arrays (they'll go in as spares)

got till here..


>  - grow the arrays to 4 members (this avoids any loss of redundancy)

now the next step.. that's a raid1 array.. is it possible to grow the 
arrays to 4 members?

Thank you!

Robi
