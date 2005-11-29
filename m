From: Brad Dameron <brad@seatab.com>
Subject: Re: building a disk server
Date: Tue, 29 Nov 2005 15:03:46 -0800
Message-ID: <1133305427.18476.1.camel@dhcpc226.office.pivotlink.com>
References: <E1EhDvc-00083b-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EhDvc-00083b-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-11-29 at 14:26 -0800, Jeff Breidenbach wrote:
> > I'd prefer to buy fewer, higher-capacity drives (300+ GB).  Any
> > experience with the new 500's?
> 
> I currently have 3 of the 500GB Hitachi's in a RAID-1 configuration
> using linux software RAID. So far, so good.  
> 
> In response to someone else's question, the mostly random reads are
> pretty well balanced between the disks, judging from atsar reports.
> Adding the third drive definitely helped read performance.
> 
> -Jeff

With 3 drives I would of opted for a RAID5. More storage and the
performance won't be too bad. Except writes would be somewhat slower.
Probably not to noticable on a desktop.

Brad Dameron
SeaTab Software
www.seatab.com


