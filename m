From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Mon, 03 Feb 2014 00:34:13 -0600
Message-ID: <52EF3865.4000106@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EE9445.2020202@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/2/2014 12:53 PM, Phillip Susi wrote:

> On 02/01/2014 05:39 PM, Stan Hoeppner wrote:

>> It's not possible
>> to accurately measure IO throughput doing buffered writes.  Thus
>> O_DIRECT is needed.

> No, you can get there just fine with buffered IO as well, unless you
> have an obscenely fast array and very slow ram, the overhead of
> buffering won't really matter for IO throughput ( just the extra cpu ).

Please reread my statement above.  Now let me restate that as:

Measuring disk throughput when writing through the buffer cache isn't a
measurement of disk throughput as much as it is a measurement of cache
throughput.  Thus, such measurements do not demonstrate actual disk
throughput.

Do you disagree?

-- 
Stan
