From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 14:58:57 -0600
Message-ID: <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<4D5A98BF.3030704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5A98BF.3030704@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 9:16 AM, Joe Landman <joe.landman@gmail.com> wr=
ote:
> [disclosure: vendor posting, ignore if you wish, vendor html link at =
bottom
> of message]
>
>> The whole system needs to be "fast".
>
> Define what you mean by "fast". =A0Seriously ... we've had people tel=
l us
> about their "huge" storage needs that we can easily fit onto a single=
 small
> unit, no storage cluster needed. =A0We've had people say "fast" when =
they mean
> "able to keep 1 GbE port busy".
>
> Fast needs to be articulated really in terms of what you will do with=
 it.
> =A0As you noted in this and other messages, you are scaling up from 1=
0 compute
> nodes to 40 compute nodes. =A04x change in demand, and I am guessing =
bandwidth
> (if these are large files you are streaming) or IOPs (if these are ma=
ny
> small files you are reading). =A0Small and large here would mean less=
 than
> 64kB for small, and greater than 4MB for large.

These are definitely large files; maybe "huge" is a better word.  All
are over 100 MB in size, some are upwards of 5 GB, most are probably a
few hundred megs in size.

The word "streaming" may be accurate, but to me it is misleading. I
associate streaming with media, i.e. it is generally consumed much
more slowly than it can be sent (e.g. even high-def 1080p video won't
saturate a 100 mbps link).  But in our case, these files are basically
read into memory, and then computations are done from there.

So, for an upper bounds on the notion of "fast", I'll illustrate the
worst-case scenario: there are 50 analysis machines, each of which can
run up to 10 processes, making 500 total processes.  Every single
process requests a different file at the exact same time, and every
requested file is over 100 MB in size.  Ideally, each process would be
able to access the file as though it were local, and was the only
process on the machine.  In reality, it's "good enough" if each of the
50 machines' gigabit network connections are saturated.  So from the
network perspective, that's 50 gbps.

=46rom the storage perspective, it's less clear to me.  That's 500 huge
simultaneous read requests, and I'm not clear on what it would take to
satisfy that.

> Your choice is simple. =A0Build or buy. =A0Many folks have made sugge=
stions, and
> some are pretty reasonable, though a pure SSD or Flash based machine,=
 while
> doable (and we sell these), is quite unlikely to be close to the real=
ities
> of your budget. =A0There are use cases for which this does make sense=
, but the
> costs are quite prohibitive for all but a few users.

Well, I haven't decided on whether or not to build or buy, but the
thought experiment of planning a buy is very instructive.  Thanks to
everyone who has contributed to this thread, I've got more information
than I've been able to digest so far!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
