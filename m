From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Raid and LVM and LILO
Date: Tue, 18 Jul 2006 09:28:40 -0400
Message-ID: <44BCE208.20302@waldoware.com>
References: <44BC21B6.1080507@minicom.com.br> <44BCCDCF.9070707@waldoware.com> <44BCD9AB.1090205@minicom.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BCD9AB.1090205@minicom.com.br>
Sender: linux-raid-owner@vger.kernel.org
To: Du <eduardo@minicom.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I assume that your /boot was raid1...  I had similar issues with the 
Debian installer, trying to install a file server using LVM on top of 
RAID.  I never did work out the problem; I installed Fedora Core :-/ 
Sorry I can't be of more help :-(

Paul

Du wrote:
> Paul Waldo wrote:
>> Hi Du,
>>
>> Did you create a /boot partition?  /boot cannot be on LVM (AFAIK), and 
>> can be a regular partition or raid1.  HTH.
> The second thing I tried was that. I made a 200 MB /dev/md0 to be the 
> /boot partition and the rest to be /dev/md1 where the system will be 
> under LVM. But LILO says be that I dont have an active partition. I set 
> the /dev/md0 to be bootable, and set the 2 "Raid Linux Autodetect" 
> partitions that makes /dev/md0 bootable too. But LILO never installs...

