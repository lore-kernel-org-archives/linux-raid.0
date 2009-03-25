From: Neil Brown <neilb@suse.de>
Subject: Re: Question on RAID 10 setup
Date: Wed, 25 Mar 2009 13:23:44 +1100
Message-ID: <18889.38320.418741.501873@notabene.brown>
References: <1183FAF84E86E244938C2174EE436BAC030FBE29@NYKPCMEU306VEUA.INTRANET.BARCAPINT.COM>
	<3513de790903241515m2eeff929x855322a51117c45b@mail.gmail.com>
	<49C97161.5020207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Robinson on Tuesday March 24
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Dylan Distasio <interzone@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 24, john.robinson@anonymous.org.uk wrote:
> On 24/03/2009 22:15, Dylan Distasio wrote:
> > Hi all-
> > 
> > I would like to put together a RAID10 array utilizing 2x1TB drives and
> > 2x500 gig drives I have in my home Linux server.  Is the best way to do
> > this to create 2 separate RAID1 arrays, one for each set of drives, and
> > then a RAID0 array made up of the RAID1 ones?   I just wanted to verify
> > that I am going about this correctly, and also get input on whether
> > there are any disadvantages to this setup.  I would prefer not to split
> > these up into two separate RAID10 arrays because I want the combined
> > space available under one.   Thanks for any comments.
> 
> I think you can mix drive sizes under md RAID-10 - much as you're 
> proposing to above with your RAID-0 of different-sized RAID-1s - and md 
> will just do the Right Thing.

Incorrect.  RAID-10, as with all levels that provide redundancy and
hot-spares etc, used the same amount of space on all devices.
Only RAID0 and Linear make use of all available space.

>                               I'd go for testing that and play with 
> layouts (near, far, offset) to suit your requirements before worrying 
> about setting up RAID 1+0.
> 
> Actually with your hardware I'd probably set up a 1TB RAID-0 with the 
> 500G drives then make a RAID-5 from the 3 1TB devices (2 raw drives plus 
> one md RAID-0). If you can be bothered try benchmarking that too; as 
> well as giving you more storage I think it'll probably match the RAID-10 
> or RAID 1+0 for performance.

I think that is a very reasonable option, as is the original
suggestion.

NeilBrown
