From: Neil Brown <neilb@suse.de>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 09:52:32 +1000
Message-ID: <17965.18112.135843.417561@notabene.brown>
References: <462CC91B.8030008@dgreaves.com>
	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Accetta on Monday April 23
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This problem is very hard to solve inside the kernel.
The partitions will not be visible until the array is opened *after*
it has been created.  Making the partitions visible before that would
be possible, but would be very easy.

I think the best solution is Mike's solution which is to simply
open/close the array after it has been assembled.  I will make sure
this is in the next release of mdadm.

Note that you can still access the partitions even though they do not
appear in /proc/partitions.  Any attempt to access and of them will
make them all appear in /proc/partitions.  But I understand there is
sometimes value in seeing them before accessing them.

NeilBrown
