From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: How are reads and writes kept in order in raid5.c?
Date: Thu, 19 Feb 2004 20:07:59 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040219200054.028ffdb0@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've gotten through most of handle_stripe, but I'm still confused on one 
big thing:  The reads and the writes are separated into two separate lists 
as soon as they come into make_request.  What guarantees they are done in 
order?  I can't see any mechanism that maintains any specific ordering of 
the bion.  Just that reads are done first, when possible, then 
writes.  What am I missing?

