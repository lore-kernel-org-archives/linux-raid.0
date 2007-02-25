From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux Software RAID Bitmap Question
Date: Sun, 25 Feb 2007 09:05:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702250903120.21821@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anyone have a good explanation for the use of bitmaps?

Anyone on the list use them?

http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Data_Scrubbing

Provides an explanation on that page.

I believe Neil stated that using bitmaps does incur a 10% performance 
penalty.  If one's box never (or rarely) crashes, is a bitmap needed?

The one question I had regarding a bitmap is as follows:

The mismatch_cnt file.

If I have bitmaps turned on for my RAID DEVICES, is it possible that the 
'mismatch_cnt' will be updated when it finds a bad block?

That would be VERY nice instead of running a check all the time.

Justin.
