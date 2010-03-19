From: Nicolae Mihalache <mache@abcpages.com>
Subject: Re: slow sequential read on partitioned raid6
Date: Fri, 19 Mar 2010 07:47:42 +0100
Message-ID: <4BA31E0E.3070306@abcpages.com>
References: <4B9FD689.8060700@abcpages.com>	 <20100317092219.35393819@notabene.brown>	 <4BA0114D.9050405@abcpages.com>	 <1268783497.3781.14.camel@localhost.localdomain>	 <4BA09167.9080709@abcpages.com> <4877c76c1003171940y5bc70260mac7784452b2d4d7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003171940y5bc70260mac7784452b2d4d7c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Actually my problem as written in the subject of the mail was that the
sequential read was slow. Somebody suggested to use a file instead of
the raw partition. If the file was detected as sparse (who does that??),
it would be even faster to read not slower.

nicolae


On 03/18/2010 03:40 AM, Michael Evans wrote:
> First off, why not use a hard disk benchmark utility (their names
> escape me aside from Bonnie++) which has these issues worked out?
>
> Second, if you absolutely must try to do a benchmark with basic tools
> (that buffer and use cache) try this:
>
> dd if=/dev/zero bs=1M count=10000 | tr '\0' 't' > testfile
> dd if=testfile of=/dev/null bs=1M
>
> You may note that you'll be writing a file with Ts instead of a file
> with 0's; my method should not be detected as sparse, where as the
> case with zeros probably will be detected as sparse and simply not
> stored.
>
> If in doubt you can check the size of the file on disk with ls -ls
> If I'm reading the output correctly the left most column (size on
> disk) is in kilobyte units, even on a 4kb cluster EXT4 filesystem

