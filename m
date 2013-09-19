From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5 3-drive array failed 2 disks at once - can anything be
 saved?
Date: Thu, 19 Sep 2013 01:35:43 -0400
Message-ID: <523A8D2F.1050900@turmel.org>
References: <52332763.30901@schultzfamily.ca> <52347194.7010602@turmel.org> <52361B98.9030705@schultzfamily.ca> <52365AE8.5010807@turmel.org> <523A619F.90302@schultzfamily.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523A619F.90302@schultzfamily.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Schultz <rob@schultzfamily.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/18/2013 10:29 PM, Robert Schultz wrote:
> That all worked beautifully. Right up until I left the BackupPC running
> against a RAID array with a bad disk.
> 
> It failed again after about 30 hours. The symptoms are the same.
>
Ah, well.  "Smart" can't catch everything.  Do consider that you might
have some other hardware problem, though.  Power supply, data cable, etc.


> I think I need to bring the array back up but leave that disk offline with:
> 
> mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc
> 
> (sdd is the bad drive)
> 
> Then follow the remainder of the steps to check.

Don't bother with another check run.  It is only meaningfull if you have
all three drives.

> I have a new disk on the way. I would then add this new disk into the
> array and sync.

Yes.

> Does that sound correct?

Yes.

Phil
