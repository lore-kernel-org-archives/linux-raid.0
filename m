From: Stephen C Woods <scw@seas.ucla.edu>
Subject: Re: How to force raid to stop, cleanly? More info
Date: Wed, 9 Apr 2003 11:22:45 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304091822.LAA16207@washington.seas.ucla.edu>
References: <16019.29496.215437.669497@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16019.29496.215437.669497@notabene.cse.unsw.edu.au> from "Neil Brown" at Apr 09, 2003 11:11:20 AM
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,
   Thanks a lot, it raid did shutdown cleanly and restarted just fine,
looks like JFS isn't quite mature enough yet.

   With that in mind fiddling with fdisk implies that one can
subpartition a raid device, the FAQ doesn't seem to have any info, so
before we go and tear down what we already have.

   Does the md driver support partitions in a meaningful/useful way?

-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
