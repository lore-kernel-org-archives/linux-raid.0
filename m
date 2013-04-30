From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 16:05:38 +0200
Message-ID: <517FCFB2.3010900@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch> <20130430134534.GA14347@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130430134534.GA14347@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> On Tue Apr 30, 2013 at 03:17:30PM +0200, Roberto Nunnari wrote:
>>>  - grow the arrays to 4 members (this avoids any loss of redundancy)
>> now the next step.. that's a raid1 array.. is it possible to grow the 
>> arrays to 4 members?
>>
> Yes, there's no problem with running RAID1 arrays with more than two
> mirrors (with md anyway) - they're all identical so it doesn't really
> make any difference how many you have.
> 
> Cheers,
>     Robin

ok.. it's rebuilding.. I started with md0.. I'll wait it finishes and 
then do md1(8GB) and after that, md2(almost 2TB).. for now it seems to 
be going well, isn't it?

# mdadm -D /dev/md0
/dev/md0:
         Version : 00.90
   Creation Time : Fri Apr 22 08:20:49 2011
      Raid Level : raid1
      Array Size : 48827328 (46.57 GiB 50.00 GB)
   Used Dev Size : 48827328 (46.57 GiB 50.00 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Apr 30 16:01:40 2013
           State : clean, degraded, recovering
  Active Devices : 2
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 2

  Rebuild Status : 15% complete

            UUID : 1158db16:ee1fcafc:b6fab772:d376c644
          Events : 0.964

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       33        1      active sync   /dev/sdc1
        4       8       49        2      spare rebuilding   /dev/sdd1
        5       8       17        3      spare rebuilding   /dev/sdb1


Robi
