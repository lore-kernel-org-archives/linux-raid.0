From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two
 disks, causing silent data corruption
Date: Tue, 25 Sep 2012 12:47:10 +0100
Message-ID: <506199BE.4020009@anonymous.org.uk>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown> <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se> <152edbf7bdad33717477f174f94116b7@192.168.93.35> <20120925111438.GB13022@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120925111438.GB13022@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: jakub@gooseman.cz, Mikael Abrahamsson <swmike@swm.pp.se>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/09/2012 12:14, keld@keldix.com wrote:
[...]
> A  mirrored raid should be able to still function also for writes,
> when this is still possible. A raid10,far with 4 disks should be able to function with 2
> failed disks (in the best case). As long as all data is available and the 2 remaining functional
> disks are OK, they should be able to function fully normally. Of cause there needs to
> be warnings of the fact that 2 disks have failed. But it should not be recorded
> in the log for each write failed for the non-functioning disks.

Yes but in thise case, two adjacent devices have failed, so we cannot 
read from or write to a quarter of the array.

I think I agree that the OP's dd command, which would certainly have 
tried to write to an area of the array there was no backing store for, 
ought to have failed with an error message, and that the failure 
behaviour ought to be the same for f2 as it is for n2.

Cheers,

John.

