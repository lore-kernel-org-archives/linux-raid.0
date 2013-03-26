From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Tue, 26 Mar 2013 14:30:27 -0600
Message-ID: <51520563.6010700@harddata.com>
References: <17910863.12.1364329282837.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17910863.12.1364329282837.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/26/2013 2:21 PM, Roy Sigurd Karlsbakk wrote:
> If you have 2x4TB and you want to setup the lot for booting and data, I'd recommend doing like the NAS boxes I've seen (well, only QNAP 410 IIRC). On that one, they chose to create partitions for / and swap (and perhaps /boot), and equal-ish partitions for those used for data. On those, you can place a RAID-10, or perhaps two RAID-1s and use LVM to stripe them. The latter is far more flexible, as RAID-10 lacks most of the flexibility other RAID leverls have.
I have 4 x 2TB, actually.
I am in the middle of this install now
CentOS Anaconda installer seems to be happy with me creating a 4 disk 
RAID1  (thanks for the suggestion, Brad C!) for /boot.
And I created a 4 disk RAID10 for swap, and another for /

> If you don't need the extra IOPS from the RAID-10, I'd recommend using RAID-6 instead for even futher safety and flexibility (the ability to change to RAID-5 in need of more space, easier to grow etc).
I want the performance.
Yes, RAID6 is an option, too, but R10 should substantially outperform 
it, and makes a lot less CPU load for the trouble.
As far as growth goes, only 4 bays available , so not a factor in this 
case, at least.

Once done I will run some tests and confirm that the performance is good 
( or not).

I still have heard nothing about any problems with the versions of 
kernels and mdadm in this distro version.
So are there none??

Anyone?

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
