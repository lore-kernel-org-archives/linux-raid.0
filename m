From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: Western Digital RE3: Raid Failure
Date: Thu, 3 Sep 2009 12:24:11 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909031221160.7746@sbhezbfg.of5.nffheflf.cev>
References: <b9f8dfb10908270243u1213576cs7c5cbc743d637c1c@mail.gmail.com> <4A9C3969.8000304@gmail.com> <b9f8dfb10909030214u2144b4fag417997ff9a38f315@mail.gmail.com> <20090903110654.GC7812@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090903110654.GC7812@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: "MOgWai46[Saurceful of Secrets]" <street41@gmail.com>, Zdenek Kaspar <zkaspar82@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Sep 2009, Gabor Gombas wrote:

> On Thu, Sep 03, 2009 at 11:14:45AM +0200, MOgWai46[Saurceful of Secrets] wrote:
>
>> This is the output of smartctl -a /dev/sdc: http://nopaste.com/p/aXwmnSEphb
>
>  5 Reallocated_Sector_Ct   0x0033   197   197   140    Pre-fail  Always       -       24
> [...]
> 196 Reallocated_Event_Count 0x0032   197   197   000    Old_age   Always       -       3
>
> IMHO it's time to replace the drive. I think it also shows that TLER is
> working just as expected: timing out when the recovery would have taken
> too long.

The drive has only been spinning for 1008 hours, or about 42 days. It's
probably still under warranty, but I'd be surprised if WD (or any other
vendor) will accept an RMA since it will probably pass all its diagnostic
tests.

Note that those SMART attributes are nothing particularly scary and this is
backed up by both attributes being significantly higher than their
respective thresholds; modern drives have thousands of spare sectors, so a
few going bad is to be expected.

> Gabor

Best Regards,
Alex
