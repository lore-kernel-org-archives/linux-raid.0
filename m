From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 09 Jul 2004 16:09:13 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40EEFB69.2000206@steeleye.com>
References: <200407091929.i69JTj320289@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407091929.i69JTj320289@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

> Feature request!
> Someone add a shrink option.
> mdadm --shrink /dev/md0 --raid-disks 2
> Or does --grow allow you to decrease the number?

Yes, grow can shrink the array, despite its name.

The grow command can also change the size of the array, e.g.:

mdadm --grow /dev/md0 --size 10000000

--
Paul
