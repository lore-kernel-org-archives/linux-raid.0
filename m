From: Matthew Mitchell <matthew@geodev.com>
Subject: Re: RAID5 causing lockups
Date: Thu, 26 Jun 2003 08:32:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EFAF5DF.70104@geodev.com>
References: <200306252054340612.008AB828@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306252054340612.008AB828@ilneval.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Going along with some suggestions of other respondents, be very 
suspicious of your power cables.  I had a hell of a time getting a 
stable raid running because of dodgy power cables.  More accurately, the 
5v or 12v lines in some of the little plugs were kind of loose, and they 
would lose contact.  So get in there with a pair of teeny pliers or 
tweezers and crimp those babies on tight.

As an aside, has anyone ever experimented with any type of conductive 
compound when putting these things together?  IMO the cheesiest part of 
the setup is the crappy PC-style power connector, and I wondered about 
various solutions from compound to soldering on a PCB for a more 
reliable means of powering drives.

Best of luck to you.

Corey McGuire wrote:
> Well, two of my drives did have an older bios, but the upgrade changed nothing.
> 
> I noticed that even unmounted, as long as I didn't raidstop the device, the system still crashes.
> 
> I tried setting down my bios as much as possible, and I am looking to do the same with the kernel, 2.4.21.  I'll try the magic sysrq key, but I can't find my nulmodem cable to save my life, so I'll have to barrow one from work.
> 
> My server marches on, but without /dev/md2... I'll try just letting it sit, /dev/md2 intact, over night, but for now, I need it up, even if it is only for fits and spurts.
> 
> Thanks everyone, keep the ideas rolling in.


-- 
Matthew Mitchell
Systems Programmer/Administrator            matthew@geodev.com
Geophysical Development Corporation         phone 713 782 1234
1 Riverway Suite 2100, Houston, TX  77056     fax 713 782 1829

