From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 16:53:39 -0500
Message-ID: <4DD43FE3.7000905@hardwarefreak.com>
References: <986071.90796.qm@web65108.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <986071.90796.qm@web65108.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 3:13 PM, Gavin Flower wrote:
> --- On Thu, 19/5/11, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> From: Stan Hoeppner <stan@hardwarefreak.com>
>> Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
>> To: "Gavin Flower" <gavinflower@yahoo.com>
>> Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
>> Date: Thursday, 19 May, 2011, 6:59
>> On 5/16/2011 4:41 PM, Gavin Flower
>> wrote:
>>
>>> Motivation, existing RAID-6 swap partition
>> failed.  I am thinking I should recreate it in a new
>> format, as currently it is 'Version : 0.90', rather than
>> simply rebuild it.
>> <snip>
>>
>> Forget using a partition.  Simply use a swap
>> file.  This example creates
>> a 1GB swap file in the / filesystem.  You can locate
>> it on any
>> filesystem you wish.
>>
>> # swappoff -a
>> # dd if=/dev/zero of=/swapfile1 bs=1024 count=1048576
>> # mkswap /swapfile1
>> # swapon /swapfile1
>> # vi /etc/fstab
>> Add:
>> /swapfile1 swap swap defaults 0 0
>>
>> and remove your old entry for the failed swap partition.
>>
>> There is little performance difference between swap files
>> and swap
>> partitions with modern kernels.  The kernel will map
>> the disk location
>> of the swap file and perform direct disk access, bypassing
>> the
>> filesystem and buffer cache.
>>
>> -- 
>> Stan
>>
> 
> Thanks.
> 
> Interesting!
> 
> (Reminds me of when I first got into Linux.  Then you could have any size swap file up to 128 MB, and have up to 8 swap files, for a maximum of 1 GB. I then had about 64 MB of RAM - now I have 8 GB of RAM. Also, swap partitions were recommended.  When the 2.4 kernel first came out, it was said to be faster if you had at least 16 MB.)
> 
> I read up and could not see any benefit in changing, so I ended up 'simply' reassembling the partition.

The big benefits are flexibility, simplicity, and time consumed.  Given
your particular case it seems a bit ironic that you see no benefit in
using swap files.  The time to resolution in this case would be mere
seconds with swap files.  How much total time did you spend reassembling
your swap partition, bot command execution time, but your total time?

-- 
Stan
