From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 13:09:18 -0400
Message-ID: <44FDAF3E.1090209@waldoware.com>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FD91D1.7090501@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Steve Cousins <steve.cousins@maine.edu>
List-Id: linux-raid.ids

Steve Cousins wrote:
> Gordon Henderson wrote:
> 
>> On Tue, 5 Sep 2006, Paul Waldo wrote:
>>
>>  
>>
>>> Hi all,
>>>
>>> I have a RAID6 array and I wondering about care and feeding 
>>> instructions :-)
>>>
>>> Here is what I currently do:
>>>    - daily incremental and weekly full backups to a separate machine
>>>    - run smartd tests (short once a day, long once a week)
>>>    - check the raid for bad blocks every week
>>>
>>> What else can I do make sure the array keeps humming?  Thanks in 
>>> advance!
>>>   
>>
>> Stop fiddling with it :)
>>
>> I run similar stuff, but don't forget running mdadm in daemon mode to 
>> send
>> you an email should a drive fail. I also check each device individually,
>> rather than the array although I don't know the value of doing this over
>> the SMART tests on modern drives though...
>>  
>>
> 
> Would people be willing to list their setup? Including such things as 
> mdadm.conf file, crontab -l, plus scripts that they use to check the 
> smart data and the array, mdadm daemon parameters and anything else that 
> is relevant to checking and maintaining an array?
> I'm running the mdmonitor script at startup and a sample mdadm.conf  
> (one of 3 machines) looks like:
> 
> MAILADDR cousins@limpet-gb.umeoce.maine.edu
> ARRAY /dev/md0 level=raid5 num-devices=3 
> UUID=39d07542:f3c97e69:fbb63d9d:64a052d3 
> devices=/dev/sdb1,/dev/sdc1,/dev/sdd1
> 
> These are SATA drives and except for the one machine that has a 3Ware 
> 8506 card in it I haven't been able to get SMART programs to do anything 
> with these drives.  How do others deal with this?
> Thanks,
> 
> Steve
> 

Excellent idea, Steve.

In my crontab, I have this:
# Check RAID arrays for bad blocks once a week
30 2 * * Tue echo check >> /sys/block/md0/md/sync_action ; echo "Checking md0 bad blocks"
30 2 * * Wed echo check >> /sys/block/md1/md/sync_action ; echo "Checking md1 bad blocks"

I have this in my smartd.conf:
/dev/hda -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/hdc -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/hde -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/hdg -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/sda -d ata -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/sdb -d ata -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)
/dev/sdc -d ata -H -m root -S on -o on -I 194 -s (S/../.././02|L/../../6/03)

My Fedora Core box has this in /etc/init.d/mdmonitor:
daemon --check --user=root mdadm ${OPTIONS}
where OPTIONS="--monitor --scan -f --pid-file=/var/run/mdadm/mdadm.pid"


I have no mdadm.conf.  My entire filesystem consists of md0 (/boot) and md1(/).  
I figure if I have problems and need the file, it won't be available anyway.  If I am mistaken,
please do let me know!

Any other suggestions would be welcomed!

Paul
