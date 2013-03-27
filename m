From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 15:18:38 -0700
Message-ID: <CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra>
	<51534450.8050905@hardwarefreak.com>
	<CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
	<51535252.2080105@hardwarefreak.com>
	<CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com>
	<51536DDD.5010800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51536DDD.5010800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 27, 2013 at 3:08 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 3/27/2013 4:06 PM, Mark Knecht wrote:
>
>> All that said, I still don't really know if I was starting over today
>> how to choose a new chunk size. That still eludes me. I've sort of
>> decided that's one of those things that make you guys pros and me just
>> a user. :-)
>
> Chunk size is mostly dictated by your workload IO patterns, and the
> number and latency of your spindles.

Is there a way for me to measure, say over a whole day or some fixed
time, what the workload really looks like?

The machine is a basic Gentoo desktop machine running KDE. The only
workload where I really care about performance is that I run a bunch
of Virtualbox Win 7 & Win XP VMs where I need to the performance to be
as good as I can reasonably get. The problem I have is these VMs are
either 1 huge file (40-50GB in a single file) or many 2GB files. I
haven't a clue how Windows & Virtualbox is accessing what it sees as a
virtual drive and then underlying that how the vbox drivers are using
the system to get to the RAID.

It would be interesting to set some program running, probably on a
weekend or sometime when performance isn't so critical, and see what
sort of data gets collected, assuming there's a program that does that
sort of thing.

Thanks,
Mark
