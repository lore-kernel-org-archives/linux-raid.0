From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: AS/CFQ/DEADLINE/NOOP on Linux SW RAID?
Date: Sun, 30 Dec 2007 11:43:16 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712301142090.9845@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When setting the scheduler, is it possible to set it on /dev/mdX or is it 
only possible to set it on the underlying devices which compose the sw 
raid device? /dev/sda /dev/sdb and does that really affect how the data is 
accessed by specifying the underlying device and not mdX?

Justin.
