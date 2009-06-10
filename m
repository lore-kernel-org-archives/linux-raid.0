From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Strange RAID behaviour when faced with user error
Date: Wed, 10 Jun 2009 23:23:16 +0100
Message-ID: <4A303254.8060106@anonymous.org.uk>
References: <20090610215835.GA4936@clouds> <4A303178.5060208@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A303178.5060208@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2009 23:19, I wrote:
> The device node /dev/sdb1 was turned into a md one - probably 9,127 - 
> when you started the array, and stopping the array hasn't reverted it. 

Or possibly /dev/sdb1 was turned into a symlink to /dev/md127.

> mknod /dev/sdb1 8 17 would probably have fixed it.

Sorry, mknod /dev/sdb1 b 8 17, after removing the symlink if that's what 
it is.

> Assuming you're using 
> udev, the /dev/sdb1 device is recreated the next time you reboot, so the 
> problem goes away.

Cheers,

John.

