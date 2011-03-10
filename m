From: hansbkk@gmail.com
Subject: Re: Growing a raid array online with different capacity disks
Date: Thu, 10 Mar 2011 20:51:18 +0700
Message-ID: <AANLkTi=42cLRctc-3mHokC5FyO55=n6j3si_xm_5y+r1@mail.gmail.com>
References: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
	<alpine.DEB.1.10.1103101356210.7942@uplift.swm.pp.se>
	<AANLkTikPK+GZp9p1Z6wXio6tAQneQyp_EcE2j+HA2KXo@mail.gmail.com>
	<20110310183650.6a631c13@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110310183650.6a631c13@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes the systems cited by the OP have nothing to do with RAID5, and in
fact are proprietary - definitely as in "non-standard", and I think
also none are open source.

They do seem to have a lot of flexibility - mix and match any number
and size of drives, toss another random-sized drive in an expand your
capacity. Apparently particularly well-suited to hobby/soho/sme users;
I've especially heard good things about Drobo for that market.

Think of the usual reaction a corporate IT guy (used to what he calls
"normal RAID", ie not mdadm) first hears about setting up mdadm RAID10
on odd numbers of drives, even say 3 - like "huh??!!"


On Thu, Mar 10, 2011 at 8:36 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 10 Mar 2011 14:24:24 +0100
> jimbob palmer <jimbobpalmer@gmail.com> wrote:
>
>> Oh I'm not proposing it, I'm asking if mdadm can do it, like the other
>> products can.
>
> No 'product' can 'do' a 1+1+1+3 TB RAID5, or it will not be a RAID5 but
> something else.
>
> --
> With respect,
> Roman
