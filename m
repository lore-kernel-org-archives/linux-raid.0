From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Does "--write-behind=" have to be done at create time?
Date: Thu, 28 Jun 2007 23:22:07 +0930
Message-ID: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was wanting to try out the "--write-behind" option. I have a raid1
with bitmaps and write-mostly enabled, which are all the pre-requisites,
I think.

It would be nice if you could tweak this parameter on a live array, but
failing that, it is hard to see why it couldn't be done at assemble
time. mdadm wont let me though.

Is this a fundamental limitation?

A related question, if I do recreate the same array, with exactly the
same parameters (except for the write-behind value) will my data still
be OK?


-- 
Ian Dall <ian@beware.dropbear.id.au>
