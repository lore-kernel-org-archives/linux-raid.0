From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 12:43:31 -0600
Message-ID: <52F134D3.20704@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com> <52F12CA0.1030803@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F12CA0.1030803@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Larry Fenske <LFenske@SGI.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/4/2014 12:08 PM, Phillip Susi wrote:

> Or the obvious and dropping the cache first, the way hdparm -t does.

"hdparm -t" is a read test.

Everything we've been discussing has been about maximizing write
throughput.  The fact that you argue this at this point makes it crystal
clear that you don't have no understanding of the differences in the
read/write paths and how buffer cache affects each differently.  Further
discussion is thus pointless.

-- 
Stan
