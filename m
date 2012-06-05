From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 14:09:19 +0100
Message-ID: <20430.1303.6379.122789@tree.ty.sabi.co.UK>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
	<CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com>
	<CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com>
	<CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> Good call. But the resync is done before the mkfs.xfs is finished, so
>> the time of the copying is not affected by resync.
>> 
>> I re-tested with --assume-clean and as expected it has no impact.

>    Wanna try CONFIG_MULTICORE_RAID456? :-)

That would be intreresting, but the original post reports over
6GB/s for pure checksumming, and around 400MB/s actual transfer
rate. In theory there is no need here for multihreading. There
may something else going on :-).

[ ... ]
