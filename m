From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Mon, 15 Dec 2008 20:32:55 -0600
Message-ID: <cccedfc60812151832r4208a36cx3c42f9c1764208de@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18757.62097.166706.244330@notabene.brown>
	 <cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
	 <18758.52536.345145.238926@notabene.brown>
	 <cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
	 <18759.678.74091.236787@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.678.74091.236787@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 7:21 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> I hope this helps.
>
> Yes it does, though I generally prefer to get more complete logs.  If
> I get the surrounding log lines then I know what isn't there as well
> as what is - and it isn't always clear at first which bits will be
> important.

Quite literally the rest of /var/log/messages was stuff unrelated
(dhcp, etc...). However, I'll try to include more context next time.

> The problem here is that --incremental doesn't provide the --re-add
> functionality that you are depending on.  That was an oversight on my
> part.  I'll see if I can get it fixed.
> In the mean time, you'll need to use --re-add (or --add, it does the
> same thing in your situation) to add nbd0 to the array.

Why does it usually work as though I *had* used --re-add (and
specified the right array)?


-- 
Jon
