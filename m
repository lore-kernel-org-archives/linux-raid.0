From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: problems with dm-raid 6
Date: Tue, 22 Mar 2016 00:04:56 +0100
Message-ID: <20160321230456.GA16913@EIS>
References: <20160321213829.GA16677@EIS>
 <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: lists@colorremedies.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 11:42:00PM +0100, Patrick Tschackert wrote:
> Based on your advice, I'll use an overlay on the array

Below the array. Assemble an array of overlay disks with two missing.
One of the missing disks should be that spare you synced in, because 
that's one of the prime suspects... actually if it was synced to it 
should not be the cause of mismatches, but if there are mismatches 
then it's likely the data that was synced to it is not good.

Although RAID is able to detect mismatches, it can not tell 
which is the valid data and which is the invalid data so ... 

Definitely assemble without that disk and without each other 
disk in turn; so for each attempt two disks missing from 
your RAID-6, hopefully one of them is a bad egg and with it 
gone, things will look better to btrfs than they do now.

The ultimate cause of those many mismatches remains a mystery.

Of course you can also attempt to repair btrfs directly but 
if btrfs redundancy is not equal to RAID-6 then it won't be 
able to fix. (I think you already cleared that point on 
the btrfs mailing list and would not be asking here if 
btrfs had the magic ability to recover)

Regards,
Andreas
