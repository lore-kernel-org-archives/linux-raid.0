From: Neil Brown <neilb@suse.de>
Subject: Re: Superblock V 1.2
Date: Tue, 16 Nov 2010 06:47:46 +1100
Message-ID: <20101116064746.24aafe7b@notabene.brown>
References: <20101107191507.GA31052@cons.org>
	<E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com>
	<20101107210852.GA77472@cons.org>
	<4CD71C77.4030400@anonymous.org.uk>
	<20101109163512.GA15649@cons.org>
	<4CD98021.2060501@anonymous.org.uk>
	<20101115121158.20e2e53e@notabene.brown>
	<20101115161646.GA38828@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115161646.GA38828@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Nov 2010 11:16:46 -0500
Martin Cracauer <cracauer@cons.org> wrote:

> Neil Brown wrote on Mon, Nov 15, 2010 at 12:11:58PM +1100: 
> > 
> > When mdadm does auto-assemble an array that doesn't obviously belong to this
> > host, it tries to be careful and assembles it 'read-auto', which means that
> > it is completely read-only until you try to write to the array.  So no
> > recovery or resync happens.
> > Once you write to the array, md assumes that you are happy to have the array
> > assembled on this device, and allows any resync etc to start.
> 
> Speaking of which, are there any plans to do a true readonly mode?
> 
> I missed that quite a few times.
> 
> Martin

In what does
   mdadm --readonly /dev/mdXX

not meet your needs?
(which is to say:  I think there is a true readonly mode, but I've never
seriously used it so don't know for certain that it is actually useful).

NeilBrown

