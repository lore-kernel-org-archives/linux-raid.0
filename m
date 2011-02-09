From: NeilBrown <neilb@suse.de>
Subject: Re: Single-drive RAID0
Date: Wed, 9 Feb 2011 13:45:57 +1100
Message-ID: <20110209134557.4e607451@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 8 Feb 2011 16:15:53 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Neil,
> 
> I try to create a single-drive RAID0 array with data preservation.
> It means I have a single disk with partitions and data on them. 
> I would like to migrate this single disk to RAID0 array and then grow it to N devices.
> Of course I expect partitions with my useful data will be mapped to corresponding MD block devices (/dev/md126p1, /dev/md126p2 etc.). Indeed they are but when I try to mount new block device it disappears from /dev directory and mount is not succeeded. 
> /var/log/messages shows all the time: 
> md126: p1
> md126: detected capacity change from 0 to xxxxxxxxxxxxx
> 
> It is not always reproducible but very often.
> I try this operation on 0.9 and imsm metadata. Symptoms are similar.
> 
> Do you have any suggestions? How to fix this issue?
> 
> Regards
> Krzysztof

It isn't clear to me what the issue is and when I try something that might be
what you are suggesting it works perfectly every time.

Maybe if you could provide something more detailed and specific.
e.g. a series of steps that I can try together with all the messages you get
(both from the kernel and from mdadm) throughout the process.

That will probably help.

NeilBrown
