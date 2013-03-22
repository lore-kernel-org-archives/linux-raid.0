From: Mirko <mirko76@arcor.de>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 12:53:28 +0000 (UTC)
Message-ID: <loom.20130322T134448-923@post.gmane.org>
References: <loom.20130322T084406-543@post.gmane.org> <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> According to the above you removed device 3 not device 7....device 3
> is missing...device 7 is still there and is a spare.

Thats right. 
 
> Put what you though was 7 back
This device no longer exists.

> ...note that properly determining which
> device is which is pretty difficult unless you have a commercial grade
> wired enclosure from a tier 1 vendor that is actually labeled and
> wired correctly (don't always count on that).

I thought, every device has its fixed device number in the raid:

mdadm -E /dev/sd[a-f]1 | grep Role
   Device Role : Active device 1
   Device Role : Active device 5
   Device Role : spare
   Device Role : Active device 0
   Device Role : Active device 4
   Device Role : Active device 2


