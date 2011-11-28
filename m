From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: linear raid, is partial recovery possible?
Date: Mon, 28 Nov 2011 16:08:13 -0600
Message-ID: <4ED4064D.2060907@hardwarefreak.com>
References: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl> <20111128205100.GA8900@cthulhu.home.robinhill.me.uk>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111128205100.GA8900@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/28/2011 2:51 PM, Robin Hill wrote:

> Well, I'd recommend against using linear RAID anyway. There's no
> redundancy at all, and no performance benefits. You'd be better off
> using the separate disks as separate filesystems.

Yes.  Linear arrays have limited use in very specific scenarios.
Normally one would only use a linear array that consists of hardware or
software RAID constituent devices, such as the example in my previous email.

At minimum a linear array should be composed of multiple mirrored drives
(RAID1).  As Robin mentioned, if you can't do redundancy for some
reason, simply format each disk with your favorite filesystem and mount
those filesystems somewhere in your UNIX directory tree.

-- 
Stan
