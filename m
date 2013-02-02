From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid1 read balance with write mostly
Date: Sat, 02 Feb 2013 15:52:12 -0600
Message-ID: <510D8A8C.5090505@hardwarefreak.com>
References: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <36edd03089332985af9a97eeaf719cd3@mail1.volny.cz>
Sender: linux-raid-owner@vger.kernel.org
To: tomas.hodek@volny.cz
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/2/2013 11:38 AM, tomas.hodek@volny.cz wrote:
> Hi
> 
> I have started to test md raid1 with one ssd and one hdd devices on 3.7.1 kernel (it has trim/discard on raid1). This raid has enabled write behind option and HDD device has enabled write mostly option.
> Original idea of write mostly option was "Read requests will only be sent if there is no other option."
> 
> My first simple test workload was a building latest stable kernel (3.7.1) using 16 threads.
> But i saw some reading from hdd irrespective of a write workload, I saw also more then 1000ms read await while ssd had await about 1ms.  (I only used iostat -x.)
> 
> I wanted to know why. I searched in source codes and i found  read_balance function in raid1.c.
> 
> If I read well this code and understand it - it do:
> 
> If a device has "write mostly" option and if we still have not selected device for reading (and if is_badblock function is ended with true), code select this device directly. This direct selection may be a mistake because overwrite this direct selection is possible only in special cases - if other possible device (without write mostly option) is idle or a request is a part of sequential reads. Standard way read_balance function is searching the nearest and/or the least used device. Such device is using only if we have not a directly selected device (also from write mosty code path).
> 
> 
> I thing all code sequence 
> 
> best_disk = disk; 
> continue;
> 
> in main for loop is not best way and that setting 
> 
> best_padding_disk  = disk;
> best_dist_disk = disk;
> 
> is better because it give chance find better alternative. In other words - change direct selection to worst possible alternative. 
> But i am not sure in all cases.

Did you test with a RAID1 of two mechanical drives?  I can envision a
scenario of say a 300GB WD Raptor 10K mirrored to a 300GB partition on a
3TB 5K 'green' drive.  The contents being the root filesystem, mirrored
strictly for safety.  This is probably the same scenario you have in
mind.  But in this case the IOPS performance difference is only 2:1,
whereas with the SSD it's more than 50:1.  So under heavy read load, in
this case we'd probably want the slow 3TB drive to contribute to the
workload.  With your patch, will it still do so?

-- 
Stan


> 
> I  made 2 version of a small patch to do it which change direct selection to setting write mostly device only as most distant and most pending possible device. Safe version is safe and reliable for future changes, now version is minimal for current code (up to 3.7.5). 
> 
> This patch work well for me. I can mark ssd as fail, remove from and add in raid under workload without any trouble or additional kernel log items.
> 
> I attach my patches to email.
> 
> Best regards
> Tomas Hodek 
> 

