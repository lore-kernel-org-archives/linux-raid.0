From: Brad Campbell <brad@wasp.net.au>
Subject: Re: consistency detect
Date: Mon, 11 Oct 2004 12:54:01 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416A4A29.9080906@wasp.net.au>
References: <1097465522.3111.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097465522.3111.24.camel@localhost.localdomain>
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:
> I have a question on RAID error detect. hope somebody can help me to
> find it out. thanks.
> 
> take raid1 as an example, if one disk fail, raid 1 can detect the data
> on disk is compromised and then reconstruct it using a spare disk. this
> is straight forward.
> 
> but if one request comes to raid1 and raid1 sends requests to both
> disks, at this time, system reboots because power outage, system
> crashes, or any other reason. then after system reboots, how raid 1
> detects which disk has consistent data? since before reboot, anything
> can happen, data may in disk1 but not in disk2, or in disk2 but not in
> disk1, or not in both disks, or already on both disks.
> 
> how raid1 or other raid code deal with this?

In short, it does not deal with it at all. RAID will deal with a disk failure, it has no guarantees 
about consistency on power failures, hard lockups or other catastrophic events.

A UPS is cheap insurance against consistency issues in combination with a journalling filesystem.

Brad
