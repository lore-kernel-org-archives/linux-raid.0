From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Disk vibration video from Sun Microsystems ( .. and the effect on
 performance .. )
Date: Thu, 1 Jan 2009 13:43:54 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901011337390.18214@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

This was posted in a filesystem irc chat:
http://blogs.sun.com/brendan/entry/unusual_disk_latency

Pretty interesting stuff, it also makes you wonder how much resonance is 
acceptable for an array and besides using dtrace/etc how could one measure 
it?  I know with 3ware you can turn on dpmstat etc for the higher end 9xxx 
controllers to check iops per disk etc, but not all hosts may have 3ware 
controllers, so besides making sure you utilize anti-vibration 
devices/techniques (rubber washers etc) how could one measure this?

Justin.
