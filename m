From: Michael Renner <michael.renner@geizhals.at>
Subject: Re: Logging-Loop when a drive in a raid1 fails.
Date: Tue, 14 Dec 2004 11:19:21 +0100
Message-ID: <41BEBE29.5090500@geizhals.at>
References: <41BD2E02.8020100@geizhals.at> <41BDB049.6060201@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BDB049.6060201@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Michael Renner wrote:
> 
>> one of the drives in a software raid1 failed, on a machine running 
>> 2.6.9-rc2, leading to this "logging-spree" (see attachment).
> 
>> Sorry if this has been fixed in the meanwhile; it's not that easy to 
> 
> It has. I sent the patch to Neil Brown a while back to fix this problem. 
> I believe it made 2.6.9.

Ok, good to hear.

>> test codepaths for failing drives with various kernels without having 
>> access to special block devices which support on-demand-failing.
> 
> mdadm -f /dev/md0 <drive>
> 
> roughly approximates a drive failure

IIRC this doesn't touch any codepaths which are involved in handling 
unreadable blocks on a block device, rescheduling block reads to another 
drive, etc, so this isn't a real alternative to funky block devices ;).

>> Furthermore I'm a bit concerned about the overall quality of the md 
>> support in 2.6
> 
> 
> I don't think you should be. md in 2.6 (as of 2.6.9 or so) is as stable 
> as 2.4, at least according to our stress tests.

Including semi-dead/dying drives? As I said, normal operation is rock 
solid, it's just the edgy, hardly used stuff which tend(s|ed) to break.

best regards,
michaely
