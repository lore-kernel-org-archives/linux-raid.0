From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux software RAID vs. udev
Date: Tue, 4 May 2004 12:11:16 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16534.64452.67783.81354@cse.unsw.edu.au>
References: <4092FCA6.2020103@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kevin P. Fleming on Friday April 30
To: kpfleming@backtobasicsmgmt.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 30, kpfleming@backtobasicsmgmt.com wrote:
> I'm switching my boxes over to udev and fully hotplug-driven /dev 
> directories.
> 
> However, that means by default I only have /dev/md0 from the MD driver, 
> and if I want to "mdadm --assemble" any other array I have to manually 
> create the device node for it first.
> 
> Is there any chance that mdadm is going to learn how to assemble an 
> array without having the device node for it already present? If so, then 
> the starting of the array would get the device node created (since it 
> would be a new block device) and everything would be happy...

catch-22.  mdadm needed the device to pre-exist.  That is how the md
driver works.

Maybe udev needs to be taught to be more open minded about these
things.

NeilBrown
