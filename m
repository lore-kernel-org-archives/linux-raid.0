From: Markus Gehring <markus.gehring@infinia.de>
Subject: Re: RAID1 Corruption
Date: Mon, 17 Jan 2005 20:42:10 +0100
Message-ID: <41EC1512.10907@infinia.de>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net> <200501171704.10374.andrew@walrond.org> <41EC0371.9060106@infinia.de> <41EC0E7F.5090303@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EC0E7F.5090303@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Paul Clements <paul.clements@steeleye.com>
List-Id: linux-raid.ids

Paul Clements wrote:
> Hi,
> 
> Markus Gehring wrote:
> 
>> I have a reproducable problem with corrupted data read from a 
>> RAID1-array.
>>
>> Setup:
>>  HW:
>>   2 S-ATA-Disks (160GB each) -> /dev/md4 RAID1
>>   Promise S150 TX4 - Controller
>>   AMD Sempron 2200+
>>
>>  SW:
>>   Fedora Core 3
>>   Kernel 2.6.10 unpatched
>>   Samba (for read/write-accesses)
>>   SW-Raid
>>
>> Everything works fine with only one drive in the array. If the second is
>> synced up read accesses return corrupted data.
>>
>> Interesting: If you remove again the second disk. The same files will be
>>  read correctly again (no matter if written while only one disk is in
>> the array or two are synced!)!
> 
> 
> This makes it sound like bad data is getting written to the second disk 
> during resync. Could you give more details about your test procedure (a 
> script or list of steps that reproduces the problem would be great)?
1. Setup Array (mdadm -C /dev/md4 -l 1 -n 2 /dev/sdc1 /dev/sdd1)
2. ... resync running (as i can see with cat /proc/mdstat)
3. mke2fs /dev/md4
4. mount /dev/md4 /home2
5. Copy ~100M JPGs (~800k each) via samba to array (/home2/test1/)
6. See the JPGs all okay
7. after resync has finished: Copy same ~100M JPGs to array (/home2/test2)
8. See the JPGs (at least in /home2/test2... i didn't check them in 
..test1) damaged
9. remove one disk again (mdadm /dev/md4 -f /dev/sdd1
mdadm /dev/md4 -r /dev/sdd1 ... or ../dev/sdc1!!!)
10. see (from the Win Client) the JPGs in /home2/test2 okay again!


> I don't think samba is the culprit, but just to be sure, is there any 
> chance you could reproduce the problem without samba in the equation? 
> (From what you say above, I assume all reads and writes are coming from 
> a samba client of some sort?)
I did a quick test:
Copyied my test-JPG-dir from /home/test (where i can see the pics okay) 
to /home2/test9 and see the pics damaged. After i copied them back to 
/home/test9 the stay damaged.

Remarks:
I also saw here that the pics on the syncing /dev/md4 = /home2 are 
damaged (read?) while the drive is syncing (new compared to point 6 
above) but this happens definitly not so often as if the drive has 
finished syncing (saw this the first time while dealing with the problem 
for over 2 weeks now).
I have all mounts on SW-Raid1 arrays, but i have never seen problems 
with md0 (/boot), md1 (/), md2 (swap), md3 (/var).
I have seen ext3-fs errors also (see also Sven Andras's posting from 
today and 5.1.2005).

Many Thanks,
  Markus

