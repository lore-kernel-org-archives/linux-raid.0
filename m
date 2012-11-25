From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 13:31:06 +0100
Message-ID: <1759500.SiuUO4mi0r@workstation-home>
References: <50B1BCBD.70306@zytor.com> <20121125101306.GA2373@lazy.lzy>
Reply-To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121125101306.GA2373@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday 25 November 2012 11:13:06 Piergiorgio Sartor wrote:
> On Sat, Nov 24, 2012 at 10:37:49PM -0800, H. Peter Anvin wrote:
> > I was looking at the hot-replace (want_replacement) feature, and I
> > had a thought: it would be nice to have this in a form which
> > *didn't* fail the incumbent drive after the operation is over, and
> > instead turned it into a spare.  This would make it much easier and
> > safer to periodically rotate and test any hot spares in the system.
> > The main problem with hot spares is that you don't actually know if
> > they work properly until there is a failover...
> 
> I go for this one.
> 
> Actually, this was also my original thinking for
> the "proactive replacement".
> 
> The only thing that, in addition, should be done,
> is to keep the spare in sleep mode until needed
> (either for hot replacement or for real replacement).
> 
> bye,

Hello, personally I would vote for an option to rotate spares into and array 
like Peter suggests, keeping a drive idle doesn't guarrantee that it's 
actually operational.

/Tommy
