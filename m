From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recent drive errors
Date: Thu, 21 May 2015 06:45:54 -0600
Message-ID: <21066296.95yN8USVxi@balsa>
References: <3296560.sGbn0HyrQY@balsa> <84264713.v03zHsT0Cj@balsa> <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu 21 May 2015 09:58:48 AM Mikael Abrahamsson wrote:
> On Tue, 19 May 2015, Thomas Fjellstrom wrote:
> > How many UREs are considered "ok"? Tens, hundreds, thousands, tens of
> > thousands?
> 
> I will replace any drive that have developed UNC sectors a few times, so
> I'd say "less than 10".

In this case, it looked like 5 UNC errors for a single sector, and some weird 
latency patterns, till I ran badblocks -w on it, then it gave me > 10k 
relocated sectors and many thousands more uncorrectable sectors. Before the 
badblocks test, it "looked" ok, now It's most definitely dead.

> +1 on the "set kernel timeout to more than 120 seconds". I have this in
> /etc/rc.local:
> 
> for x in /sys/block/sd[a-z] ; do
>          echo 180  > $x/device/timeout
> done
> 
> echo 4096 > /sys/block/md0/md/stripe_cache_size

I presume it's ok to do that even if the drives do ERC/TLER? Just woke up, but 
my brain seems to be telling me it shouldn't break anything since the ERC 
drives should always return after 7s no matter what...

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
