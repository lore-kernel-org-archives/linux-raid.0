From: Andy Smith <andy@strugglers.net>
Subject: Re: RAID10 reshape and change lout possible?
Date: Sun, 26 Feb 2017 21:17:28 +0000
Message-ID: <20170226211728.GE21587@bitfolk.com>
References: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
 <20170226185147.GD21587@bitfolk.com>
 <3ef7f0b2-1f3e-40e2-ab23-3ff9436f9ced@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ef7f0b2-1f3e-40e2-ab23-3ff9436f9ced@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Sun, Feb 26, 2017 at 09:28:34PM +0100, Reindl Harald wrote:
> Am 26.02.2017 um 19:51 schrieb Andy Smith:
> >https://manpages.debian.org/jessie/mdadm/mdadm.8.en.html suggests
> >that --grow --layout can be changed on RAID-10.

[…]

> [root@testserver:~]$ mdadm --grow /dev/md0 --layout=f2
> mdadm: Cannot reshape RAID10 to far-mode

Hmm, that man page says that Debian jessie has version 3.3.2-5 and
still it says:

Grow

[…]

    …changing the chunk size and layout for RAID 0,4,5,6,10 as well
    as adding or removing a write-intent bitmap.

So is the man page wrong?

Admittedly until I looked I thought RAID-10 couldn't be reshaped at
all in any way. And now I don't know at all. :)

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
