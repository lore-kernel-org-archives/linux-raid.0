From: Jody McIntyre <scjody@sun.com>
Subject: Re: Strange RAID behaviour when faced with user error
Date: Fri, 12 Jun 2009 14:33:40 -0400
Message-ID: <20090612183339.GB4936@clouds>
References: <20090610215835.GA4936@clouds> <4A303178.5060208@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <4A303178.5060208@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 10, 2009 at 11:19:36PM +0100, John Robinson wrote:

> The device node /dev/sdb1 was turned into a md one - probably 9,127 -  
> when you started the array, and stopping the array hasn't reverted it.  
> mknod /dev/sdb1 8 17 would probably have fixed it. Assuming you're using  
> udev, the /dev/sdb1 device is recreated the next time you reboot, so the  
> problem goes away.

That's exactly right.  Thanks for the insight!

brw-rw---- 1 root disk 9, 127 2009-06-10 17:54 /dev/sdb1

> I think mdadm 3.0 would have deleted the device node when the array was  
> stopped, but mdadm 2.6.x doesn't.

Actually, mdadm 3.0 is even smarter than that:

# ls -l /dev/sdb1
brw-rw---- 1 root disk 8, 17 2009-06-12 13:40 /dev/sdb1
# ./mdadm --version
mdadm - v3.0 - 2nd June 2009
# ./mdadm --assemble --verbose /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
mdadm: device /dev/sdb1 exists but is not an md array.

Cheers,
Jody
