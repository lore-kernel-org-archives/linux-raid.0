From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing
 Soft RAID under Linux)
Date: Sun, 28 May 2006 10:08:19 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605281004010.30550@twinlark.arctic.org>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
 <20060528133203.GC8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060528133203.GC8203@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 May 2006, Luca Berra wrote:

> - mdadm-2.5-rand.patch
> Posix dictates rand() versus bsd random() function, and dietlibc
> deprecated random(), so switch to srand()/rand() and make everybody
> happy.

fwiw... lots of rand()s tend to suck... and RAND_MAX may not be large 
enough for this use.  glibc rand() is the same as random().  do you know 
if dietlibc's rand() is good enough?

-dean
