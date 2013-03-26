From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Tue, 26 Mar 2013 17:35:55 +0800
Message-ID: <51516BFB.8030006@fnarfbargle.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5150E665.2090902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/03/13 08:05, maurice wrote:

> What about partitioning the drives first, installing a smallish
> partition for boot, then a second much larger partition on each for the
> RAID10?
> Do you think that the CentOS installer and GRUB would have any issues
> with that layout?

This is how I have a Debian server set up.
The system is on 6 SSD's. Each ssd has a small partition and a big 
partition. All the small partitions are set up in a 6 way RAID1 as ext2 
for /boot, and the big partitions are in a RAID10,n2. This RAID10 is 
then partitioned with GPT to provide / /home /opt.

Can't comment on the Centos part, but the method is sound.


