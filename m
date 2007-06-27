From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: deliberately degrading RAID1 to a single disk, then back again
Date: Wed, 27 Jun 2007 18:23:59 -0400
Message-ID: <4682E37F.9080303@laurelnetworks.com>
References: <4681546B.4030709@harddata.com> <Pine.LNX.4.64.0706261421430.3561@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706261421430.3561@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> mdadm /dev/md0 --fail /dev/sda1
> 
> On Tue, 26 Jun 2007, Maurice Hilarius wrote:
> 
...
>>> From time to time I want to "degrade" back to only single disk, and turn
>> off RAID as the overhead has some cost
>>> From time to time I want to restore to RAID1 function, and re-synch the
>> pair to current.
>>
>> Yes, this is a backup scenario..
>>
>> Are there any Recommendations ( with mdadm syntax)  please?

Plus

   mdadm /dev/md0 --remove /dev/sda1

to take the drive out of the array and

   mdadm /dev/md0 --add /dev/sda1

to put it back and start the re-sync.

When you mention "turn off RAID" do you mean to not even bring up the disk
as a degraded array?  If all you do is fail and remove the partition, RAID is
actually still running to manage the single remaining partition, but I would
expect that overhead to be minimal.
-- 
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
