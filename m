From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Tyan, RAID-6, and other recent hassles... (long, a bit OT)
Date: Sat, 19 Feb 2005 13:57:59 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502191220130.819@lion.drogon.net>
References: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net>
 <42172E56.3040007@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <42172E56.3040007@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Feb 2005, berk walker wrote:

> Do you want a glass or some cheese?

Not really... I just thought I'd pass on my experiences and thank those
who gave me support recently. By posting my configurations and thoughts
and issues I've encountered during the way, I'm essentially opening mys=
elf
up for a peer review if you like. I'm not saying my way is the best way=
,
but it's one way. If others can learn from it, great. If they want to
criticise it, thats also good, but it's only good if it's constructive.

But a glass of Old Peculiar would go down nicely, thanks :)

> Actually, I am thinking that your main problem is a generic [almost]
> BIOS issue, as no one in "right mind" would expect your configuration=
=2E

Expect my configuration ... what? To work? Why not? It's a motherboard
with 4 PCI-X slots and a single 32-bit PCI slot. Why shouldn't it work?

Or do you mean expect my configuration to exist at all as you think it'=
s
utterly preposterous?

Right now it's working well, and it's about to be installed at the clie=
nts
site where it'll run and be thrashed for a week at least before we put
live data on it. Even then, we'll keep the old server (which it's
replacing) going for a month or so until we're finally happy with it.

I'm sure there is a BIOS or motherboard/chipset problem though and Tyan
have some sorting out to do.  I have emailled them with all my issues a=
nd
concerns, but not had anything back yet.

> Might I suggest a somewhat more expensive, yet safer work-around?

=46eel free...

> Split your drives between more boxes and gigabite link them.  If you
> work this well, you will have increased the survival of disk/other
> failures - stick 'em in the mail room, or where-ever.

The server that this box is replacing has 12 disks. (Which I built some
years back) This has 8. It has 12x the disk capacity and cost less than
1/3 the old server did. It has redundant PSUs bought from a company tha=
t
has been supplying server cases for over 10 years. It'll be installed i=
n
an air-conditioned machine room with dual 16KVA UPSs... Why should this
server with multiple disks pose a problem?

I've built many servers with multiple disks, and they all work well,
after-all, thats what this mailing list is about - Linux with multiple
disks!

I've had to work round buggy motherboards in the past (Dual Athlon boar=
ds)
and in that respect, this is not much different. I did at one point hav=
e 2
(server) motherboards which had the "exploding capacitor" problems, but
fortunately we were able to secure replacements before they actually
exploded.

One requirement for this server is for a very large filestore. TB or
greater. I won't get that if I split the disks between servers. (Can yo=
u
build an md device from network block devices?) I'm using RAID-6 as I'v=
e
been bitten in the past with a 2-disk failure. (and been able to recove=
r
from it by using mdadm and advice given to others via this mailing list=
)

This server will have a backup server, identical in configuration
(although that's arguably not the best solution). The critical data wil=
l
be backed to tape (as it is currently on the server it's replacing) and=
 we
have a good program of tape cycling with off-site backups being held. T=
he
file-store part just has to be reliable - it's all re-generable (progra=
m
binaries, libraries, etc) so it doesn't have to be backed up to tape.

The client already has nearly a dozen other fileservers which I've buil=
t
for them over the years. This isn't the one server to serve them all, i=
t's
just one small piece in their network of servers.  They are a small
silicon design co. but they have a huge data storage requirement.
(Ironically their data storage requirements increases almost in proport=
ion
to Moores Law :)

And tomorrow I'll be installing their first Gigabit Ethernet switch. Th=
is
server box has Gb Ethernet. (although I have graphs from all their exis=
ting
switches to prove that they don't actually need Gb Ethernet, but it's t=
he
way of the future, isn't it?)

> You have spent some big bux to set this up, spend a few more and hard=
en
> it. Eh?

I haven't spent "big bux" at all. I've (or rather my client) has spent
less than =A34K for 2 identical servers. I've spent a lot of time on it=
,
sure, but my time comes at a constant cost for this client, so isn't a
factor in this. I'd rather spend a lot of time on it now, than rushing =
it
into place and then have to spend more time on it in the future. They a=
re
getting the server 2-3 weeks later than originally planned, but they ca=
n
live with that. (And I'm 100 miles from their site, so not having to ru=
sh
up the motorway if it does fail is a plus-point for me)

My client is a small company. 40 people, limited funds, (and no mail
room!), but great ideas. They've gone through good times and bad times
over the years I've been working with them.  Right now is a good time, =
but
money is still tight. I agree that you get what you pay for, but someti=
mes
you just have to make do. When times have been good, they've bought Del=
l
servers which I've installed Debian and s/w RAID on, and it's all "jsut
worked", but when times aren't so good, you have no choice but to sourc=
e
from scratch and build according to budget. These servers will serve th=
e
purpose they want - affordable storage and compute for the application
they have been built for (a combined MySQL/CVS home-grown application, =
as
well as a disk store).

I've been working for these guys for over 6 years now, and in that time
all the servers I've built for them have been gracefully retired rather
than gone terminally tits-up. I'm quite proud of that. It's not been ea=
sy,
but with time and perseverance, and good help from the "community"
everythings worked out just fine. The first server I built for them is =
now
sitting next to me at home still running. It had 4 x 18Gb drives which =
we
very soon upgraded to 8 18Gb drives, both drive sets running s/w RAID 5=
=2E
It had 100GB of storage on it 5 years ago, and its performance (for the
day) was stellar. Nowadays that's just peanuts, but thats progress for
you!

> Just an old guy rambling-

Gordon,
  just another old guy making a living.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
