From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: Making RAIDS with firewire drives -- changing device IDs.
Date: Sat, 25 Oct 2003 16:26:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067113572.12841.41.camel@binkley>
References: <114.2a8b6710.2ccc3560@aol.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <114.2a8b6710.2ccc3560@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I understand that mdadm can use UUIDs to identify drives. It's not clear to 
> me whether each disk or partition that belongs to an array gets the SAME UUID 
> number on it -- allowing mdadm to find all the disks that go together.  Or does 
> each member of an array gets its own UUID and somewhere there's a record of 
> all the UUIDs that go together? And if it's the latter, where is that record 
> kept? 

it's the former.


> Regardless of the answer to the above question, my bigger question is, will 
> UUIDs give me a way of guaranteeing that I'll be able to start and manage my 
> arrays even if the device labels (sda1, sdb1, etc.) change from what they were 
> when I created the arrays? Do I have to record a UUID for each drive? Or only 
> from each array? 

yes - it guarantees that you can start the array.


> (I also understand that all the involved device names must be listed in the 
> mdadm.conf file. However, I'm not sure whether it would be bad to list ALL 
> firewire devices (sda, sdb, etc.) in the mdadm.conf file, even if some of them are 
> NOT part of any of the arrays listed there? If I had 12 firewire drives 
> involved in arrays, but two that weren't, would it be bad to list all 14 in the 
> mdadm.conf file if I wasn't sure which ones didn't belong to any arrays?) 

look at --scan and --assemble .


-sv


