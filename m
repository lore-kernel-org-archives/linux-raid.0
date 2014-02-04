From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Mon, 03 Feb 2014 21:30:21 -0600
Message-ID: <52F05ECD.5060804@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EFAACE.40906@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/3/2014 8:42 AM, Phillip Susi wrote:

> On 2/3/2014 1:34 AM, Stan Hoeppner wrote:
>> Please reread my statement above.  Now let me restate that as:
>>
>> Measuring disk throughput when writing through the buffer cache
>> isn't a measurement of disk throughput as much as it is a
>> measurement of cache throughput.  Thus, such measurements do not
>> demonstrate actual disk throughput.
>>
>> Do you disagree?
> 
> Yes, I do because cache throughput is >>>> disk throughput.

It is because buffer cache throughput is greater that measurements of
disk throughput are not accurate.  If one issues a sync after writing
through buffer cache the measured throughput should be fairly close.
But without issuing a sync you're measuring buffer cache throughput.

Thus, as I said previously, it is better to do parallel O_DIRECT writes
or use AIO with O_DIRECT for testing disk throughput as one doesn't have
to worry about these buffer cache issues.

-- 
Stan

