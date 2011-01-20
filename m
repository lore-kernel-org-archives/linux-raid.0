From: NeilBrown <neilb@suse.de>
Subject: Re: cpu/memory use
Date: Thu, 20 Jan 2011 12:29:17 +1100
Message-ID: <20110120122917.3eb0a888@notabene.brown>
References: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 22:14:45 -0200 Roberto Spadim <roberto@spadim.com.b=
r>
wrote:

> Hi, i wass thinking about cpu/memory use
> i have a dual (three four) cpu
> could i make linux to only use cpu1 for raid? and others to anythink
> else, don=B4t migrate raid between cpus... and don=B4t allow others
> programs to use raid cpu...
> is it possible?
> is it dificult?
> it=B4s more linux related feature, not raid related, but could we imp=
lement it?
> what about memory usage? how many memory software raid use? is it per
> device, per raid, does it have a hard limit (offcourse)? could we
> calculate it? for example i want raid1 with two disks of 1tb, how man=
y
> memory should i buy?
>=20

=46or levels other than RAID4/5/6, md/raid does not use any significant=
 amount
of CPU or memory.

=46or RAID4/5/6, md's use for CPU is single-threads so it will only use=
 a
single CPU - which ever one the scheduler allocates it to from time to =
time.

The only room for improvement that I can see would be to allow the 'xor=
'
calculation to be run in parallel on multiple CPUs and that would only =
help
if the storage devices were nearly as fast as a CPU.  Where we have tri=
ed
parallelising xor, it has only made things slower.=20


=46or your particular question about RAID1 - use a RAID1 across two dev=
ices
would use less than 100K more than using just one of the devices.
During resync it might use as much as a couple of megabytes of extra me=
mory.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
