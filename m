From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Fri, 12 Feb 2016 09:34:59 -0500
Message-ID: <wrfja8n62e0c.fsf@redhat.com>
References: <20160211162959.GG13969@merlins.org>
	<alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Fri, 12 Feb 2016 10:30:22 +0100 (CET)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:
> On Thu, 11 Feb 2016, Marc MERLIN wrote:
>
>> But can someone confirm that indeed if I have a single md device,
>> and 4 CPUs, my throughput is not limited by a single CPU decrypting
>> the device?
>
> There have been multiple discussions about this over time, and since
> you didn't qualify "not good" with a number, it's hard to say if this
> is your problem or not.

About a year ago when I last received a new laptop, I put btrfs on top
of luks - it was a rather miserable experience. The system would freeze
up and be really slow.

I believe the issue was btrfs not acting well with crypto underneath it,
and there was hallway talk confirming this but I have no hard data. In
the end I gave up and put my /home on xfs on top of LUKS and used btrfs
for the uncrypted portions.

It may be the btrfs with crypto issues have been resolved since then.

Cheers,
Jes
