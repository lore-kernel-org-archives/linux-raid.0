From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 14:50:05 -0600
Message-ID: <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 2:34 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> That's not true. A drive that can sit there like a bump on the log for 2 minutes before it issues an actual read failure on sector(s) means mdadm is likewise waiting, and everything above it is waiting. That's a long hang. I'd not be surprised to see users go for hard reset with such a system hang after 45 seconds let alone 2 minutes.
> 
> Ideally what you'd get is a quick first error recovery with a clean normally operating array. As soon as the first drive fails, the system would set the remaining drives to a slightly longer error recovery time so that you don't get nearly as quick error recovery on the remaining drives - ask them to try a little harder before they error out. If you get another read error, there is no mirror or parity to rebuild from. Best to try a little longer in such a degraded state.

In fact the long error recovery of consumer drives *prevents* automatic correction by md. At least it significantly delays the correction.

That drive, if it can recover a sector in 30 seconds (let alone 2 minutes) instead of failing it, will not be corrected; md won't get an alternate from mirror or from parity, and won't overwrite that obvious flakey sector. So instead you get a propensity for bad sector accumulation, even in the case of regular check scrubs.

For any serious use I just wouldn't use the Greens, without very non-consumer like scrubs, extended smart tests, and cycling out drives so they could be ATA Enhance Secure Erase nuked say once a year or maybe more often. And a rigorous backup. With that kind of expertise and dedication should come a better budget for a better drive.


Chris Murphy