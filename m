From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is this likely to cause me problems?
Date: Thu, 23 Sep 2010 14:14:35 +0100
Message-ID: <4C9B52BB.1060204@anonymous.org.uk>
References: <965225.13513.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <965225.13513.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/09/2010 15:38, Jon Hardcastle wrote:
[...]
> Thanks for your help. I have been doing some background reading and am concinving myself to leave the boundaries as they are as it appears there is performance gains to be had? Assuming this is true as long as the parition size is LARGER than the other 1TB paritions I should be ok, right?
>
> Device Boot         Start  End          Blocks
> /dev/sda1              63  1953520064   976760001
> /dev/sdc1            2048  1953525167   976761560
>
> If i subtract Start from End
> sda = 1953520064 - 63   = 1953520001
> sdc = 1953525167 - 2048 = 1953523119 (3118 larger than sda)
>
> as long as sdc is larger which it is by 3118 I should be ok right?
>
> I am even thinking about individually removeing my drives from the array and letting fdisk use its new calculations for the existing drives. I could do with better performance!

Don't do that. There is no performance benefit from aligning your 
partitions. There would be a performance benefit to making LVM align 
itself correctly over md RAID stripes, and the filesystem over LVM or md 
RAID, but there is no performance benefit from aligning md RAID over 
partitions, *unless* you have 4K sector drives or SSD.

Honestly you are better off duplicating your original partition table 
onto your new drive so all your partitions are the same, mostly so there 
can't be any more confusion later on.

Cheers,

John.
