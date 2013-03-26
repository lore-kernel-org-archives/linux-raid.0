From: maurice <mhilarius@gmail.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Tue, 26 Mar 2013 09:16:08 -0600
Message-ID: <5151BBB8.6090604@gmail.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com> <51516BFB.8030006@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51516BFB.8030006@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/26/2013 3:35 AM, Brad Campbell wrote:
> ..
> The system is on 6 SSD's. Each ssd has a small partition and a big 
> partition.
> All the small partitions are set up in a 6 way RAID1 as ext2 for 
> /boot, and the big partitions are in a RAID10,n2.
> This RAID10 is then partitioned with GPT to provide / /home /opt.
>
> Can't comment on the Centos part, but the method is sound.
>
>
Ah, good idea on the small RAID1. Keeps it all synchronized.
Nice.

Thank you!



-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
