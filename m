From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Tue, 1 Jun 2010 23:03:56 -0500
Message-ID: <C3.C0.03062.D28D50C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Carlos Mennens' <carloswill@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Carlos Mennens
> Sent: Tuesday, June 01, 2010 12:08 PM
> To: Mdadm
> Subject: RAID Configuration For New Home Server
> 
> I built a new home server this weekend & am ready to load my O.S.
> (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
> (SATA). I don't really have a specific function of this server at home
> beyond holding my data reliably and decent read / write performance.
> My question to you experts is what do you recommend I configure for
> this particular configuration? Should I run RAID 5 or RAID 10? To
> spare or not to spare? I really appreciate any best suggestions for
> general over all function on this matter.

	Well, really, you need to define your needs more thoroughly and then
configure the system accordingly.  What constitutes "decent" performance?
How is the server attached to your LAN?  What sort of load is the server
going to encounter?  How much down time can you tolerate in the event of a
failure?  If your LAN is only 100Mbps or worse wireless, then any RAID
system is going to deliver better performance than the LAN connection can
handle.  If you have one or perhaps even multiple Gig-E links into the LAN,
however, it's a  very different matter.  How many workstations do you have
online simultaneously, and what horsepower?  What application mix?  My
servers, for example, have Gig-E links into the LAN, and I have several
moderately high power workstations attached, but usually only 1 or 2 are
active at a time, and much of what is served is video with a maximum of 25
Mbps or so.  The main server has a 12 x 1T RAID6 array and the backup has a
9 x 1T RAID6 array.  The only time they are ever loaded anywhere near
capacity is when backup up to or restoring from the backup server, and even
then the bottleneck is often the 1Gbps Ethernet links.

	Also, what many people fail to take into account is growth.  Your
decision should include a growth strategy.  RAID10 is fine for 4 drives, but
if the data is likely to eventually reach more than 6 drives in extent,
RAID10 - with a minimum of 12 drives and counting, isn't so attractive.  In
my case, for example, a pair of 9T RAID10 arrays would not only cost a great
deal to build, but the power requirements would also be significant.

	Your backup strategy is also a factor.  Having a backup server
online as I do means the marginally greater risk of a RAID5 system over a
RAID6 might be worth it for a relatively small number of member disks.
Indeed, both servers were RAID5 until each respective system exceeded 6 data
discs, at which point they were migrated to RAID6.

	I suggest you think about your needs a little more carefully and
detail them here concisely, and we can make better recommendations.

