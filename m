From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 18:59:14 +0100
Message-ID: <52C84BF2.5030503@gmail.com>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C835C9.3050707@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/04/2014 05:24 PM, Phil Turmel wrote:
> Side note: If you have a live spare available for a raid5, there's no
> good reason not to reshape to a raid6, and very good reasons to do so.

I used to have a setup like that (i.e. RAID5 + spare), and my reason was
power consumption and heat dissipation, since the spare was spun down.

Jan

