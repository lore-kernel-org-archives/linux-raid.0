From: Mitchell Laks <mlaks@verizon.net>
Subject: RE: raid5 initialization errors during boot not after boot. raid5 driver loaded both times.
Date: Mon, 10 Jan 2005 17:47:39 -0500
Message-ID: <200501101747.39273.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 
Mike Hardy answered my question:

The reason that raidstart was not working during bootup was that I did  not 
have the driver for the highpoint rocket 133 that provided the mount points
/dev/hde and /dev/hdg loaded in initrd.img.

As soon as i added the hpt366 module to the initrd, IT WORKED!!!!

thanks to your Mike,

And thank you wonderful list members for your help! !!
Mitchell
