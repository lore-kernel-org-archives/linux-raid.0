From: "Dylan Distasio" <interzone@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 28 Dec 2008 10:53:00 -0500
Message-ID: <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am far from an expert also, but have some experience with my own
RAID 5 array using mdadm.

It looks like one drive is giving you an issue when you are trying to
force the assembly:

mack ~ # mdadm -A --force /dev/md0 /dev/sd{a,b,c,d,e}3
mdadm: superblock on /dev/sdd3 doesn't match others - assembly aborted

Have you tried assembling the array degraded to see if you can force
it without sdd3?  I don't know if this is the best solution, but if
that works, you can then readd sdd3 and have the array rebuild.
