From: "Lucas Albers" <admin@cs.montana.edu>
Subject: Re: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 19:34:37 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1433.153.90.196.102.1086140077.squirrel@web1.cs.montana.edu>
References: <002501c44837$64699a20$0201a8c0@windows>
    <20040602012500.12304.qmail@web61004.mail.yahoo.com>
Reply-To: admin@cs.montana.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040602012500.12304.qmail@web61004.mail.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a system that uses drives on all channels, eg master/slave.
and I have encountered any slowdown, by using primary and secondary disks
in the same channel.
Yes it is slower, but for me performance is good enough.

It serves upwards of 100gigs of data over the network per day.
I use mdadm on all my raid systems, as it was easier to setup and has
automatic email notification.
I wrote a document on using mdadm. http://rootraiddoc.alioth.debian.org

I'm trying to put hot spares in my systems because I'm getting perhaps 1
disk failed every 2 weeks to a month.
It does seem a waste of space, but hard drives are cheap.

-- 
Luke Computer Science System Administrator
Security Administrator,College of Engineering
Montana State University-Bozeman,Montana

