From: Alex Davis <alex14641@yahoo.com>
Subject: RE: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 17:44:18 -0700 (PDT)
Message-ID: <824925.21830.qm@web50201.mail.re2.yahoo.com>
References: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
Reply-To: alex14641@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <lkml@metanurb.dk>, David Greaves <david@dgreaves.com>, David Lethe <david@santools.com>
Cc: David Rees <drees76@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



I code, therefore I am


--- On Fri, 5/2/08, David Lethe <david@santools.com> wrote:
[snipped]
> I was being too literal. md is a good solution (I use it
> myself).  However, the OP wanted to "Make sure that if
> one disk dies, the data is still in tact".  
I was also concerned about performance. It seems that if the RAIDs will 
be used heavily and independent of each other, and performance is a 
concern, then dedicated disks (and possibly dedicated controllers)
are the better option.


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
