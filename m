From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Mon, 04 Sep 2006 17:13:18 -0400
Message-ID: <1157404398.2990.14.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
	 <1157385612.2990.4.camel@localhost>  <1157403347.2990.11.camel@localhost>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1157403347.2990.11.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This one will really curl your hair.  So, operating with the knowledge
that the checksum's state of correctness or incorrectness was changing
all the time, I did this:

while [ $? != 0 ] ; do
	mdadm -A /dev/md0 /dev/sd[abcd]1
done

after 1,518 trials it successfully assembled.

*beats head against wall*

-- 
Josh Litherland (josh@temp123.org)

