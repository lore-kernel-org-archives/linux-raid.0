From: David Greaves <david@dgreaves.com>
Subject: Re: Simulating Drive Failure on Mirrored OS drive
Date: Mon, 02 Oct 2006 09:02:13 +0100
Message-ID: <4520C785.8010709@dgreaves.com>
References: <4520555B.4080000@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4520555B.4080000@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

andy liebman wrote:
> I tried simply unplugging one drive from its power and from its SATA
> connector. The OS didn't like that at all. My KDE session kept running,
> but I could no longer open any new terminals. I couldn't become root in
> an existing terminal that was already running. And I couldn't SSH into
> the machine.
That's likely to be because sata hotswap isn't supported (yet).
dmesg should give you more info.

 > I know that simply unplugging a drive is not the same as a drive failing
> or timing out. But is there a more realistic way to simulate a failure
> so that I can know that the mirror will work when it's needed?

Read up on the md-faulty device.

Also, FWIW, md works just fine :)
(Lots of other things can go wrong so testing your setup is a food idea though)

David
