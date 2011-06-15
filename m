From: Gordon Henderson <gordon@drogon.net>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Wed, 15 Jun 2011 10:11:33 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1106150958480.5704@unicorn.drogon.net>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com> <20110611000000.76ca58e7@natsu> <BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com> <BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com> <4DF65758.2030405@gmail.com>
 <BANLkTi=2xO5ZR5Vy2Qb2WJPzCPesy32nkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="180569313-302278285-1308128901=:5704"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=2xO5ZR5Vy2Qb2WJPzCPesy32nkA@mail.gmail.com>
Content-ID: <alpine.DEB.2.00.1106151009440.5704@unicorn.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--180569313-302278285-1308128901=:5704
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1106151009441.5704@unicorn.drogon.net>

On Mon, 13 Jun 2011, Mathias Burén wrote:

> On 13 June 2011 19:30, Tim Blundell <tim.blundell@gmail.com> wrote:
>>
>> On 6/11/2011 5:49 AM, Mathias Burén wrote:
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Caviar Green (Adv. Format) family
>>> Device Model:     WDC WD20EARS-00MVWB0
>>> Serial Number:    WD-WMAZ20188479
>>> Firmware Version: 50.0AB50
>>> User Capacity:    2,000,398,934,016 bytes
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   8
>>> ATA Standard is:  Exact ATA specification draft version not indicated
>>> Local Time is:    Sat Jun 11 10:48:05 2011 IST
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>
>> Not certain if this was mentioned. While WDC WD20EARS drives can be used in
>> an RAID array, WD recommends using there RAID capable drives in an
>> enterprise environment.
>> I tried using same drives in a simple RAID-1 array and had serious
>> performance issues (sync taking a week) and stalls when writing to disk. Are
>> you using the stock firmware on these drives?

> I'm using stock firmware as far as I know (I've not flashed them
> manually), and I experience no performance issues. Of course, my
> system is limited (RAID6 with an Intel Atom), so I can't really push
> them all out to test it. But still, no issues.

I've just put a pair into my own workstation - which is an Atom (2 core/4 
threads) with 2GB of RAM, running stock Debian Squeeze, however I've just 
installed my own kernel... (2.6.35.13)

They work just fine! Sync took overnight to complete on all partitions.

I'm a fan of multiple partitions, so my /proc/mdstat looks like:

Personalities : [linear] [raid0] [raid1] [raid10]
md1 : active raid1 sdb1[1] sda1[0]
       1048512 blocks [2/2] [UU]

md2 : active raid10 sdb2[1] sda2[0]
       8387584 blocks 512K chunks 2 far-copies [2/2] [UU]

md3 : active raid10 sdb3[1] sda3[0]
       2096128 blocks 512K chunks 2 far-copies [2/2] [UU]

md5 : active raid10 sda5[0] sdb5[1]
       922439680 blocks 512K chunks 2 far-copies [2/2] [UU]

md6 : active raid10 sdb6[1] sda6[0]
       1019538432 blocks 512K chunks 2 far-copies [2/2] [UU]

And a quick & dirty speed test looks like:

# hdparm -tT /dev/md{1,2}

/dev/md1:
  Timing cached reads:   1080 MB in  2.00 seconds = 539.70 MB/sec
  Timing buffered disk reads: 352 MB in  3.01 seconds = 116.76 MB/sec

/dev/md2:
  Timing cached reads:   1106 MB in  2.00 seconds = 552.92 MB/sec
  Timing buffered disk reads: 534 MB in  3.00 seconds = 177.78 MB/sec

which are numbers I'm quite happy with.

md1 is raid1 as I wasn't sure if LILO likes RAID10 yet. It just contains 
root. My 'df -h -t ext4' output looks like:

Filesystem            Size  Used Avail Use% Mounted on
/dev/md1             1008M  235M  722M  25% /
/dev/md2              7.9G  4.2G  3.4G  55% /usr
/dev/md5              866G  178G  645G  22% /var
/dev/md6              958G  200M  909G   1% /archive

With these drives (WDC EARS) it is absolutely essential that you partition 
them correctly - partitions *must* start on a 4K aligned boundary (sector 
must be evenly divisible by 8) They have a 4K physical sector size, but a 
512K logical sector size - and as Linux also uses a 4K block size, then 
any mis-alignment seriously degrades drive performance.

Gordon
--180569313-302278285-1308128901=:5704--
