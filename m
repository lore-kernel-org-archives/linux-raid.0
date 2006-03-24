From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 that used parity for reads only when degraded
Date: Fri, 24 Mar 2006 09:19:22 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603240907020.20234@twinlark.arctic.org>
References: <loom.20060323T003324-767@post.gmane.org>
 <17441.59458.918847.175664@cse.unsw.edu.au> <1143175107.7404.88.camel@starfire>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1143175107.7404.88.camel@starfire>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 Mar 2006, Alex Izvorski wrote:

> Also the cpu load is measured with Andrew Morton's cyclesoak
> tool which I believe to be quite accurate.

there's something cyclesoak does which i'm not sure i agree with: 
cyclesoak process dirties an array of 1000000 bytes... so what you're 
really getting is some sort of composite measurement of memory system 
utilisation and cpu cycle availability.

i think that 1MB number was chosen before 1MiB caches were common... and 
what you get during calibration is a L2 cache-hot loop, but i'm not sure 
that's an important number.

i'd look at what happens if you increase cyclesoak.c busyloop_size to 8MB 
... and decrease it to 128.  the two extremes are going to weight the "cpu 
load" towards measuring available memory system bandwidth and available 
cpu cycles.

also for calibration consider using a larger "-p n" ... especially if 
you've got any cpufreq/powernowd setup which is varying your clock 
rates... you want to be sure that it's calibrated (and measured) at a 
fixed clock rate.

-dean
