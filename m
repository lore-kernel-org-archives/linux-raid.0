From: Luca Berra <bluca@comedia.it>
Subject: Re: ATA Raid on a Dual Boot (Win 2K and Linux [kernel 2.6])?
Date: Fri, 29 Apr 2005 10:51:19 +0200
Message-ID: <20050429085118.GB21154@percy.comedia.it>
References: <4270F5D6.2060004@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4270F5D6.2060004@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 28, 2005 at 04:40:22PM +0200, Stefan Muenkner wrote:
>As far as I know, Linux should be seeing all the partitions made for the
>"hardware" raid windows setup as being separate partitions on the two
>hard disks (identical layout). So I should be able to mirror them using
>sw-raid.

i would not be confident in having md over a fakeraid, sooner or later
the fakeraid will overwrite one of the two md superblocks with the copy
from the other disk, so if you really want to do this, you should use
dmraid instead.

note, there is no bootloader which is yet able to boot from lvm over
dmraid, you will need a separate /stand for the moment.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
