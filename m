From: Brett Russ <bruss@netezza.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 09:19:44 -0500
Message-ID: <hj73e0$anm$1@ger.gmane.org>
References: <252597.38481.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <252597.38481.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/19/2010 05:04 AM, Jon Hardcastle wrote:
> I kicked off a check/repair cycle on my machine after i moved the
> phyiscal ordering of my drives around and I am now on my second
> check/repair cycle and it has kept finding mismatches.
>
> Is it correct that the mismatch value after a repair was needed
> should equal the value present after a check? What if it doesn't?
> What does it mean if another check STILL reveals mismatches?
>
> I had something similar after i reshaped from raid 5 to 6 i had to
> run check/repair/check/repair several times before i got my 0.

I think to diagnose this you'll need to show us the results of running 
'mdadm -E /dev/[hs]dX#' (i.e. /dev/sda2) for each member device in the 
md device you're trying to assemble *before* attempting to start the md 
device.  This will report on the state of that specific member device 
(partition) and will show why a resync/repair would/would not be needed.

Note that if your md device is not in a read-only mode that the member 
states may be changing underneath you as you run the above command. 
Therefore, you should either stop the device then run the commands, or 
at least have the device in a read-only mode first.

-BR

