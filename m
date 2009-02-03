From: "John Stoffel" <john@stoffel.org>
Subject: Re: bonnie++ on md device causes reboot on new motherboard
Date: Tue, 3 Feb 2009 10:22:19 -0500
Message-ID: <18824.24876.76210.433309@stoffel.org>
References: <20090203041450.GA2107@sewage.raw-sewage.fake>
	<4988061B.2020904@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4988061B.2020904@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


David> Matt Garman wrote:
>> Anyone seen anything like this or have any ideas where I can start
>> looking for more information?

David> netconsole?
David> http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt

Or a serial console...

David> At least then you may see what the error is.  And for a crash
David> like this I'd contact your distro kernel team too (not sure
David> about lkml with 2.6.24 but probably)

From the sounds of it, it's a Hardware problem of some sort.  I'd run
a full memtest86 on the box, as well as some sort of CPU torture.
Check all your cables, possibly remove two of the four disks, etc.

Remove as much memory as possible, re-seat memory board, etc.  Have
you checked the BIOS version?  Have you reset the BIOS defaults to the
'safe' or 'default' settings?  Don't bother tweaking stuff to get more
speed, go for stability.  The second you have porblems with stability,
you've lost all that time you saved by tweaking things.  :]

John

