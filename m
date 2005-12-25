From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: Poor RAID6 performance on frankenstein server
Date: Sun, 25 Dec 2005 18:07:06 +0800
Message-ID: <dolr6m$5hv$1@sea.gmane.org>
References: <20051225023230.GA5047@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051225023230.GA5047@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trevor Cordes wrote:
> ...However, the way the Plextor works is the audio is
> software-encoded into MP3 on the fly (ie: not in the Plextor like the
> video).

I would be tempted to look at the path the audio takes from the plextor 
to the disk. Clearly it goes via the CPU. Seems like there's a 
bottleneck there somewhere - some bus bandwidth issues (does USB share 
the same bus as the disk [ie PCI] at any point?) - I don't know that 
chipset (Intel 845D). Does it depend on which disk array you copy to/from?

...but, no, I don't really know what I'm talking about...so take it for 
what it's worth.

Max.

