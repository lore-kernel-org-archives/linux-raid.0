From: Andy Smith <andy@strugglers.net>
Subject: Re: RAID10 reshape and change lout possible?
Date: Sun, 26 Feb 2017 18:51:47 +0000
Message-ID: <20170226185147.GD21587@bitfolk.com>
References: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On Sun, Feb 26, 2017 at 03:37:24PM +0100, Reindl Harald wrote:
> is it somehow possible to change a existing md RAID10 array from "2
> near-copies" to "2 far-copies" and what would be the mdadm syntax?

https://manpages.debian.org/jessie/mdadm/mdadm.8.en.html suggests
that --grow --layout can be changed on RAID-10. I have never tried
it myself. Experiment with loop devices. It looks like the syntax
would be:

# mdadm --grow /dev/mdX --layout=f2

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting

> The optimum programming team size is 1.
Has Jurassic Park taught us nothing?         — pfilandr
