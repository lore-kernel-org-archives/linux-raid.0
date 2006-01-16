From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 09:08:50 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601160848300.2853-100000@coffee.psychology.mcmaster.ca>
References: <43CB9FE3.60803@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CB9FE3.60803@emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>, linux-raid@vger.kernel.org, "Butler, Tim" <Butler_Tim@emc.com>
List-Id: linux-raid.ids

> > Using iorate.c, I guess somewhat different numbers for the 2.6.15 
> > kernel than
> > for the 2.6.8 kernel - the 2.6.15 kernel starts off at 105MB/s and 
> > head down
> > to 94MB/s, while 2.6.8 starts at 140MB/s and heads town to 128MB/s.
> >
> > That seems like a significant difference to me?

yes that's surprising.  I should have mentioned that the way I normally
use iorate output is to plot the incremental bandwidth as a function of 
position (disk offset).  that way I can clearly see contributions of 
kernel page-cache, possible flattening due to a bottleneck, and the normal
zoned-recording curve.

#!/usr/bin/perl
use strict;

for my $fname (@ARGV) {
    open(I,"<$fname");
    open(INC,">$fname.inc");
    open(AVG,">$fname.avg");
    while (<I>) {
        my @fields = split;
        if ($#fields == 3 && /[0-9]$/) {
            print INC "$fields[1] $fields[2]\n";
            print AVG "$fields[1] $fields[3]\n";
        }
    }
    close(AVG);
    close(INC);
}

I sometimes plot the running average curve as well, since it shows how much 
less informative the average (ala bonnie/iozone/etc) is.

> Keep in mind that disk performance is very dependent on exactly what 
> your IO pattern looks like and which part of the disk you are reading.

that's the main point of using iorate.

> We have some tests that we use to measure raw disk performance that try 
> to get through these hurdles to measure performance in a consistent and 
> reproducible way...

iorate profiles are reasonably consistent, as well.  it doesn't attempt to 
do any IO pattern except streaming reads or writes.

