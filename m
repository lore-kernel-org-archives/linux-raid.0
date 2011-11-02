From: keld@keldix.com
Subject: Re: possibly silly question (raid failover)
Date: Wed, 2 Nov 2011 08:02:21 +0100
Message-ID: <20111102070221.GA24797@www5.open-std.org>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101221539.GA1319@www5.open-std.org> <20111102092526.50b410b1@notabene.brown> <20111102013756.GA10763@www5.open-std.org> <20111102124816.33a55447@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111102124816.33a55447@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2011 at 12:48:16PM +1100, NeilBrown wrote:
> On Wed, 2 Nov 2011 02:37:56 +0100 keld@keldix.com wrote:
> 
> > On Wed, Nov 02, 2011 at 09:25:26AM +1100, NeilBrown wrote:
> > > On Tue, 1 Nov 2011 23:15:39 +0100 keld@keldix.com wrote:
> > > 
> > > > On Tue, Nov 01, 2011 at 04:13:26PM -0400, Miles Fidelman wrote:
> > > > > David Brown wrote:
> > > > > >
> > > > > >No, md RAID10 does /not/ offer more redundancy than RAID1.  You are 
> > > > > >right that md RAID10 offers more than RAID1 (or traditional RAID0 over 
> > > > > >RAID1 sets) - but it is a convenience and performance benefit, not a 
> > > > > >redundancy benefit.  In particular, it lets you build RAID10 from any 
> > > > > >number of disks, not just two.  And it lets you stripe over all disks, 
> > > > > >improving performance for some loads (though not /all/ loads - if you 
> > > > > >have lots of concurrent small reads, you may be faster using plain 
> > > > > >RAID1).
> > > > 
> > > > In fact raid10 mas a bit less redundancy than raid1+0.
> > > > It is as far as I know built as raid0+1 with a disk layout
> > > > where you can only loose eg 1 out of 4 disks, while raid1+0
> > > > in some cases can loose 2 disks out of 4.
> > > 
> > > With md/raid10 you can in some case lose 2 out of 4 disks and survive, just
> > > like raid1+0.
> > 
> > OK, in which cases, and when is this not the case?
> > 
> > best regards
> > keld
> 
> "just like raid1+0"

No, that is not the case AFAIK. Eg the layout of raid10,f2 with 4 disks is 
"just like raid0+1".

best regards
keld
