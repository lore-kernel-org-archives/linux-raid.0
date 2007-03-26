From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: LILO 22.6.1-9.3 not compatible with SW RAID1 metdata >= 1.0
Date: Mon, 26 Mar 2007 07:46:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703260741270.18194@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: johninsd@san.rr.com
List-Id: linux-raid.ids

Neil,

Using: Debian Etch.

I picked this up via http://anti.teamidiot.de/nei/2006/10/softraid_lilo/ 
via google cache.  Basically, LILO will not even run correctly if the 
metadata is not 0.90.  After I had done that, LILO ran successfully for 
the boot md device, but I still could not boot my system until I made all of
the root raid array volumes with 0.90 metadata.

Any chance the LILO guys will fix this so it works with all forms of MD 
metadata?

Justin.
