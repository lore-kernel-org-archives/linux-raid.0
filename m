From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: mdadm raid1 read performance
Date: Sat, 7 May 2011 12:58:57 +0200
Message-ID: <20110507105857.GA32569@www2.open-std.org>
References: <iptjde$92f$1@dough.gmane.org> <E8.69.09483.F8264CD4@cdptpa-omtalb.mail.rr.com> <iq37cu$stq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <iq37cu$stq$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 07, 2011 at 12:37:18PM +0200, David Brown wrote:
> On 06/05/11 23:05, Leslie Rhorer wrote:
> >	These systems use so little swap space and so rarely, I'm not sure I
> >see any benefit to RAID10,f2 for them.  Is there?
> >
> 
> Obviously when you use swap rarely, it makes little difference how it is 
> laid out on the disk.  And since it is small, there is no difference 
> between the speed of the outer and inner tracks (for HD's - for SSD's 
> there is obviously no difference), so you don't gain there.  raid10,f2 
> will still be better than raid1 for larger reads from swap - but I think 
> you would have a hard time trying to spot that effect in the real world.

I think swap on raid10,f2 mostly matters on workstations, where you have 
big apps like OpenOffice.org or firefox, and limited RAM.

best regards
keld
