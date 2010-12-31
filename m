From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: New raid level suggestion.
Date: Fri, 31 Dec 2010 04:23:30 -0600
Message-ID: <4D1DAF22.8020105@hardwarefreak.com>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au> <20101230094230.GE2986@bitwizard.nl> <4D1C616D.8030904@hardwarefreak.com> <4D1C73D4.6050600@anonymous.org.uk> <4D1C851B.3040304@hardwarefreak.com> <4D1CCB28.8030705@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1CCB28.8030705@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 12/30/2010 12:10 PM:

> I had surmised from the original question about using RAID-10, RAID-4
> etc that there was a desire to have more storage than a single drive
> mirrored twice, so I didn't think plain mirroring would suit, but
> perhaps that wasn't the intention and your solution would work.

Sorry I was a bit prickly in my reply John.  For some reason I became
defensive, and shouldn't have.  Chalk it up to mood I guess.

It's entirely possible that I misunderstood Roger's requirements.  I
believe he was talking about two different systems, one a transaction
type server in his first thread, the other just a web sever in this
thread.  That's why I recommended the possibility of simple RAID 1 for
the web server.

It's difficult for me to imagine a web server scenario that would need
anywhere close to 1TB of disk, or one that would need more IOPS than a
single disk could provide, or more fault tolerance than mirroring.  The
assumption today being that one satisfies web capacity needs with many
cheap nodes instead of one, or few, big ones.  I concede anything is
possible, and there are myriad requirements out there.  I've just never
seen/heard of a web server req for anything more than simple disk mirroring.

For instance, I've been using the following for a web node with good
success.  It's a "low power" node from both an all out performance and
heat dissipation perspective but can handle more than sufficient numbers
of simultaneous requests (it is noisy though, as all 1U units are).
Current cost of the components is less than $360 USD for a 1U 14" deep
single core 2.8GHz 45w AMD server, 4GB RAM, onboard single GigE, and 2 x
mirrored Seagate 160GB 7.2k 2.5" SATA II drives, and a single 260w PSU.
 These boxen don't have hot swap drive cages.  Using a box with hot swap
would increase total price by 35% to almost $500 per node.  Drive
failures are rare enough here that it's not a burden to de rack the
server and replace the dive, as this is a cluster web node.  For most
other server applications I use hot swap chassis (and redundant PSUs).
I run Debian Lenny on these w/lighttpd, etc.

These shallow boxen allow dog ear mounting without making me nervous, so
I save about $25-$40 per unit on slide rails.  I published the NewEgg
wish list of the parts for this build.  It should be available in a day
or so after their review process.  If anyone is interested, search the
public wish lists for "web-node".  For $70 more you can drop in a 3 core
2.5 GHz AMD and stay at 45w, if a single core 2.8 isn't enough for your
needs.  You can run up to 65w CPUs in this setup, including the latest
Phenom II 45nm quad cores.  I try to stick to 45w myself for 1U boxen.
Note these are decidedly desktop quality parts, not server, thus the <
$400 cost.  I find them more than sufficiently reliable for web nodes.

Note that the SuperMicro chassis doesn't natively support 2.5" drives,
only two 3.5" drives.  I remedy this easily with a template I made, my
DeWalt cordless drill, and a countersink bit.  Takes less than 5 minutes
to drill the 8 new mounting holes.  I much prefer the decreased
obstruction and increased airflow afforded by 2.5" drives so it's more
than worth the trouble.  For those averse to drilling on their chassis,
NewEgg has a ~$9 adapter plate which works for this application.  You'd
need two of them for two 2.5" drives.
http://www.newegg.com/Product/Product.aspx?Item=N82E16811993005
(Simply toss the dongle that comes with it as it's not needed)

Apologies for getting a little OT here. A quick glance at the RHS of my
email address will explain.  :)

-- 
Stan
