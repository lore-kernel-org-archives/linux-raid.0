From: Massimiliano Masserelli <negro@interim.it>
Subject: Re: Help!  Head crash on IDE Seconday Master.  Slave has all the data but wont boot
Date: Sun, 24 Nov 2002 02:01:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021124010146.GA3341@sgabanaz.interim.it>
References: <3DDF76C8.8070605@reveltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DDF76C8.8070605@reveltech.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 23, 2002 at 07:38:32AM -0500, Stuart Levine wrote:

> the boot loader to look at /dev/hdd instead of /dev/hdc (the dead disk 
> in the raid pair) without loosing my installed data?

Try connecting your hdd as hdc (ie, set it as master disk). No other
changes should be needed, nor should you switch it back when you will
place the new disk in (as slave, of course).

Hope it helps.
-- 
Massimiliano Masserelli
-------------------------------------------------------------------------------
We're living in a golden age.  All you need is gold.
		-- D.W. Robertson.
