From: aragonx@dcsnow.com
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 12:48:51 -0500 (EST)
Message-ID: <4eae8d29d5e663323c7be0a31c8b6262.squirrel@www.dcsnow.com>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
    <4B5EB5BD.7070406@shiftmail.org>
    <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
    <4B5EEFD7.2080407@shiftmail.org>
    <37bfaf9c6cbe90557cdef839be3ff20f.squirrel@www.dcsnow.com>
    <1264517763.30742.88.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264517763.30742.88.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> You should have also used '--assume-clean' so that no data would be
> written onto the array while the array was assembled. Saved my ass
> earlier.

A very good thing to know.  I wish I would have known earlier.  I had
tried the create trick before and it worked fine so I figured that was all
I needed to do.  This RAID stuff may be too involved for what I need.  It
is only about 2TB of data.  I may just split it up between two 2TB hard
disks and leave it be.

So I guess that opens this up to a question.  What would everyone suggest
I do.  Should I try the software RAID again?  Should I go with a hardware
controller?  Or should I just have two independent disks?

Right now I have 5 750GB disks that were part of the RAID 5.  I can of
course reuse those in whatever solution I go with.

My thinking this morning is to setup a 2nd server with the 5 750GB disks
and leave that as a software RAID.  Then I would purchase 2 2TB disks for
my current server and just use them as-is.

Throughput is a concern though.  I currently was getting 50MB/sec over the
network.  This was okay but I really wanted to get that up to 75MB/sec or
more.

Suggestions?

---
Will Y.

