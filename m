From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server? GPFS w/ 10GB/s throughput to the rescue
Date: Sat, 12 Mar 2011 16:49:44 -0600
Message-ID: <AANLkTin8PW3B9+dvumQE1VG_Ddwcc5ryDg84FFuO0wGq@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<4D5A98BF.3030704@gmail.com>
	<AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com>
	<4D66CBB8.5010804@gmail.com>
	<4D6992CE.60803@hardwarefreak.com>
	<4D69A154.3030403@gmail.com>
	<4D6A65FC.1030401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6A65FC.1030401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Joe Landman <joe.landman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry again for the delayed response... it takes me a while to read
through all these and process them.  :)  I do appreciate all the
feedback though!

On Sun, Feb 27, 2011 at 8:55 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> Yes, this is pretty much exactly what I mentioned. =A0~5GB/s aggregat=
e.
> But we've still not received an accurate detailed description from Ma=
tt
> regarding his actual performance needs. =A0He's not posted iostat num=
bers
> from his current filer, or any similar metrics.

Accurate metrics are hard to determine.  I did run iostat for 24 hours
on a few servers, but I don't think the results give an accurate
picture of what we really need.  Here's the details on what we have
now:

We currently have 10 servers, each with an NFS share.  Each server
mounts every other NFS share; mountpoints are consistently named on
every server (and a server's local storage is a symlink named like its
mountpoint on other machines).  One server has a huge directory of
symbolic links that acts as the "database" or "index" to all the files
spread across all 10 servers.

We spent some time a while ago creating a semi-smart distribution of
the files.  In short, we basically round-robin'ed files in such a way
as to parallelize bulk reads across many servers.

The current system works, but is (as others have suggested), not
particularly scalable.  When we add new servers, I have to
re-distribute those files across the new servers.

That, and these storage servers are dual-purposed; they are also used
as analysis servers---basically batch computation jobs that use this
data.  The folks who run the analysis programs look at the machine
load to determine how many analysis jobs to run.  So when all machines
are running analysis jobs, the machine load is a combination of both
the CPU load from these analysis programs AND the I/O load from
serving files.  In other words, if these machines were strictly
compute servers, they would in general show a lower load, and thus
would run even more programs.

Having said all that, I picked a few of the 10 NFS/compute servers and
ran iostat for 24 hours, reporting stats every 1 minute (FYI, this is
actually what Dell asks you to do if you inquire about their storage
solutions).  The results from all machines were (as expected)
virtually the same.  They average constant, continuous reads at about
3--4 MB/s.  You might take that info and say, 4 MB/s times 10
machines, that's only 40 MB/s... that's nothing, not even the full
bandwidth of a single gigabit ethernet connection.  But there are
several problems (1) the number of analysis jobs is currently
artificially limited; (2) the file distribution is smart enough that
NFS load is balanced across all 10 machines; and (3) there are
currently about 15 machines doing analysis jobs (10 are dual-purposed
as I already mentioned), but this number is expected to grow to 40 or
50 within the year.

Given all that, I have simplified the requirements as follows: I want
"something" that is capable of keeping the gigabit connections of
those 50 analysis machines saturated at all times.  There have been
several suggestions along the lines of smart job scheduling and the
like.  However, the thing is, these analysis jobs are custom---they
are constantly being modified, new ones created, and old ones retired.
 Meaning, the access patterns are somewhat dynamic, and will certainly
change over time.  Our current "smart" file distribution is just based
on the general case of maybe 50% of the analysis programs' access
patterns.  But next week someone could come up with a new analysis
program that makes our current file distribution "stupid".  The point
is, current access patterns are somewhat meaningless, because they are
all but guaranteed to change.  So what do we do?  For business
reasons, any surplus manpower needs to be focused on these analysis
jobs; we don't have the resources to constantly adjust job scheduling
and file distribution.

So I think we are truly trying to solve the most general case here,
which is that all 50 gigabit-connected servers will be continuously
requesting data in an arbitrary fashion.

This is definitely a solvable problem; and there are multiple options;
I'm in the learning stage right now, so hopefully I can make a good
decision about which solution is best for our particular case.  I
solicited the list because I had the impression that there were at
least a few people who have built and/or administer systems like this.
 And clearly there are people with exactly this experience, given the
feedback I've received!  So I've learned a lot, which is exactly what
I wanted in the first place.

> http://www.ibm.com/common/ssi/fcgi-bin/ssialias?infotype=3DSA&subtype=
=3DWH&appname=3DSTGE_XB_XB_USEN&htmlfid=3DXBW03010USEN&attachment=3DXBW=
03010USEN.PDF
>
> Your numbers are wrong, by a factor of 2. =A0He should research GPFS =
and
> give it serious consideration. =A0It may be exactly what he needs.

I'll definitely look over that.

> I don't believe his desire is to actually DIY the compute and/or stor=
age
> nodes. =A0If it is, for a production system of this size/caliber, *I*
> wouldn't DIY in this case, and I'm the king of DIY hardware. =A0Actua=
lly,
> I'm TheHardwareFreak. =A0;) =A0I guess you've missed the RHS of my em=
ail
> addy. :) =A0I was given that nickname, flattering or not, about 15 ye=
ars
> ago. =A0Obviously it stuck. =A0It's been my vanity domain for quite a=
 few years.

I'm now leaning towards a purchased solution, mainly due to the fact
that it seems like a DIY solution would cost a lot more in terms of my
time.  Expensive though they are, one of the nicer things about the
vendor solutions is that they seem to provide somewhat of a "set it
and forget it" experience.  Of course, a system like this needs
routine maintenance and such, but the the vendors claim their
solutions simplify that.  But maybe that's just marketspeak!  :)
Although I think there's some truth to it---I've been a Linux/DIY
enthusiast/hobbyist for years now, and my experience is that the
DIY/FOSS stuff always takes more individual effort.  It's fun to do at
home, but can be costly from a business perspective...

> Why don't you ask Matt, as I have, for an actual, accurate descriptio=
n
> of his workload. =A0What we've been given isn't an accurate descripti=
on.
> If it was, his current production systems would be so overwhelmed he'=
d
> already be writing checks for new gear. =A0I've seen no iostat or oth=
er
> metrics, which are standard fair when asking for this kind of advice.

Hopefully my description above sheds a little more light on what we
need.  Ignoring smarter job scheduling and such, I want to solve the
worst-case scenario, which is 50 servers all requesting enough data to
saturate their gigabit network connections.

> I'm still not convinced of that. =A0Simply stating "I have 50 compute
> nodes each w/one GbE port, so I need 6GB/s of bandwidth" isn't actual
> application workload data. =A0From what Matt did describe of how the
> application behaves, simply time shifting the data access will likely
> solve all of his problems, cheaply. =A0He might even be able to get b=
y
> with his current filer. =A0We simply need more information. =A0I do a=
nyway.
> =A0I'd hope you would as well.

Hopefully I described well enough why our current application workload
data metrics aren't sufficient.  We haven't time-shifted data access,
but have somewhat space-shifted it, given the round-robin "smart" file
distribution I described above.  But it's only "smart" for today's
usage---tomorrow's usage will almost certainly be different.  50 gbps
/ 6 GB/s is the requirement.

> I don't recall Matt saying he needed a solution based entirely on FOS=
S.
> =A0If he did I missed it. =A0If he can accomplish his goals with all =
=46OSS
> that's always a plus in my book. =A0However, I'm not averse to closed
> source when it's a better fit for a requirement.

Nope, doesn't have to be entirely FOSS.

-Matt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
