From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Tyan, RAID-6, and other recent hassles... (long, a bit OT)
Date: Mon, 21 Feb 2005 14:00:55 -0800
Message-ID: <421A5A17.5060902@h3c.com>
References: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net> <42172E56.3040007@panix.com> <Pine.LNX.4.56.0502191220130.819@lion.drogon.net> <421749F1.3040503@panix.com> <Pine.LNX.4.56.0502211146120.17307@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502211146120.17307@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: berk walker <berk@panix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Gordon Henderson wrote:

> to/from another server to thrash the networking, then will do stuff via
> NFS, transfer big files, checksum them, etc. as well as lots of little
> files. Anyone have a good solid testsuite then like to run?

Very off-topic at this point, but apart from transfers with checksums, I 
use a pair of ttcp processes to pack the network pipe solid, and the 
linux kernel source is a great CPU/RAM test if you unpack/untar, copy, 
diff, delete repeat

Just be sure to watch the temparature ;-)

-Mike
