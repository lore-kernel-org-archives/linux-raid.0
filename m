From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: resync (what is it doing when making a new array?)
Date: Sun, 08 Aug 2004 13:23:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87n016gvnm.fsf@enki.rimspace.net>
References: <1091924709.209ea25bc637f@www.then7.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 Aug 2004, Eli Cantu wrote:
> I cannot find an answer to my question: After creating a new array, why is the
> time consuming resync required?

Because the disks need to contain the correct data, or they will cause
faults when you try to use them after a disk failure. :)

> I've built a few hardware RAID 5 arrays in my time using Mylex, Adaptec, AMI
> etc. I don't recall this hours long, sometimes days long initial resync using
> hardware raid.

Usually, this is handled by either doing the sync in the background
quietly, or by keeping an NVRAM bitmap of "unclean" blocks that starts
with all the bits set.

Regards,
        Daniel
-- 
I have always detested the belief that sex is the chief bond
between man and woman. Friendship is far more human.
        -- Agnes Smedley

