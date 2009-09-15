From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 16:28:18 -0400
Message-ID: <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	 <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	 <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	 <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	 <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Majed B." <majedb@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>
> I've actually been doing some of those benchmarks here. =A0Given a Si=
licon
> Image 3124 card in a x1 PCI-e slot, my maximum throughput should be a=
bout
> 250MB/s (PCI-e limitation). =A0My drives behind the pm are all capabl=
e of
> about 80MB/s, and I have 4 drives. =A0What I've found is that when ac=
cessing
> one drive by itself, I get 80MB/s. =A0When accessing more than one dr=
ive, I
> get a total of about 120MB/s, but it's divided by however many drives=
 I'm
> accessing. =A0So, two drives is roughly 60MB/s each, 3 drives about 4=
0MB/s
> each, and 4 drives about 30MB/s each.
>
Doug,

I hate to ask the obvious, but you do have a 3Gbit/sec connection
between the controller and the PM, right?

I only ask because your 120MB/sec is about right for a 1.5Gbit/sec
connection.  I was under the impression you should max out closer to
250MB / sec with a good controller and PM and a 3.Gbit/sec connection.
 I have not done any testing myself.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
