From: maurice <mhilarius@gmail.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 17:21:44 -0600
Message-ID: <5150DC08.8000702@gmail.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/25/2013 5:05 PM, Chris Murphy wrote:
> On Mar 25, 2013, at 11:57 AM, maurice <mhilarius@gmail.com> wrote:
>
>> Further to this, can anyone comment on creating partitions on the RAID10 device,
>> versus making separate partitions on the devices, for installation of the OS?
> I'd partition the array, rather than make separate raid10 arrays from partitions. It's certainly easier to manage if there are issues. If a drive dies, you replace that drive, whereas if you partition the drives you have to partition it exactly right, and then add the partitions as replacements for each array you've created. I think that's a hassle.
>
> The advantage of partitioning the drives with one partition (I'd use GPT for this), is that fdisk/gdisk/parted and other utils will see each drive as being partitioned (for linux software raid) rather than appearing as free space.
>
>
> Chris Murphy
Thanks Chris.

Is there any problem with installing CentOS directly on an array in 
RAID10, as opposed to on to "regular" partitions?

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
