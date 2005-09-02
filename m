From: Brad Dameron <brad@seatab.com>
Subject: Re: 3ware RAID (was Re: RAID resync stalled at 99.7% ?)
Date: Fri, 02 Sep 2005 09:27:16 -0700
Message-ID: <1125678437.28420.1.camel@dhcpc226.office.pivotlink.com>
References: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net>
	 <87vf1jsqjj.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vf1jsqjj.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-09-02 at 20:38 +1000, Daniel Pittman wrote:
> Christopher Smith <csmith@nighthawkrad.net> writes:
> 
> [...]
> 
> > The components are 12x400GB drives attached to a 3ware 9500s-12
> > controller.  They are configured as "single disks" on the controller,
> > ie: no hardware RAID is involved.
> 
> A quick question for you, because I have a client looking at 3ware RAID
> hardware at the moment:

I would also look at the Areca line of cards. They are much faster than
the 3ware and support up to 24 port if needed. Also do RAID6 now.

http://www.areca.com.tw/index/html/index.htm


Brad Dameron
SeaTab Software
www.seatab.com

