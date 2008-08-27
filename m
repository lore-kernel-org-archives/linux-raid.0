From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: RE: Device naming and raid1
Date: Wed, 27 Aug 2008 14:42:55 +0100
Message-ID: <6974A22713584476AB62E87B84827E37@meanmachine>
References: <48B554CA.4010804@emitony.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48B554CA.4010804@emitony.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tony Coffman' <tony@emitony.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 
> Any idea on my original question?  If I re-add the drive 
> using the /dev/sdc name will I have problems on the next boot 
> when the drive is named /dev/sda?
> 
> Based on my experience with Linux and other software raid 
> implementations, I'm strongly inclined to think that the 
> device naming doesn't matter - the system will scan the 
> drives at boot looking for raid sets and re-assemble them no 
> matter what major and minor numbers or device names are.  I'm 
> not opposed to finding out the hard way but I'd really like 
> to get a definitive answer now because by the time this 
> system is next rebooted I'll probably have long forgotten about this.
> 

Not an expert in any sense of the word, but if the array is being
identified by its UUID and not by a specific list of devices in
mdadm.conf, then the array should assemble fine after a reboot with the
device names having changed.  I recently had a similar situation where I
added a new PCI-E x1 2 port SATA II card, which promptly pushed all my
other sdx devices down two places.  The raid mounted as expected and all
was/is wonderful.

Hope this helps,

Steve.

