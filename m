From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: software raid rebuilding and O_DIRECT access (xfs_repair) slowness
Date: Fri, 02 Oct 2009 07:30:41 +1300
Message-ID: <4AC4F551.2080606@sauce.co.nz>
References: <200910011949.42542.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910011949.42542.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Arkadiusz Miskiewicz wrote:

> The question is now why software raid is soo slow when device is accessed with 
> O_DIRECT by xfs_repair? (that's hch guess on what's the problem). Is this bug, 
> expected behaviour?

I would think that this is not unexpected - 2 disk bound tasks, one 
(resync), which requires the heads to sequentially step cylinder by 
cylinder from the beginning to the end.

The other, xfs_repair, which is randomly seeking all heads all over the 
platters.

Regards,

Richard
