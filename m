From: LCID Fire <lcid-fire@gmx.net>
Subject: Re: Recreate raid 10 array
Date: Fri, 10 Apr 2009 13:01:32 +0200
Message-ID: <49DF270C.4080600@gmx.net>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>	 <49DD1B87.2050804@tmr.com> <1239227842.18515.8.camel@cichlid.com> <49DD21C6.4060200@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DD21C6.4060200@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

LCID Fire wrote:
> First off the good news: I'm currently running on my raid10 again - 
> with only little data loss.
And now also some bad news again :(
Appearently something is wrong.
mount /dev/md0 /mnt
complains
mount: unknown filesystem type 'linux_raid_member'

On older kernels it works when stating ext3 as the filesystem - but with 
recent 2.6.28/mdadm it doesn't anymore.
