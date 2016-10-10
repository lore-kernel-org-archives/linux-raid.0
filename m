From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Why not just return an error?
Date: Mon, 10 Oct 2016 18:10:22 -0400
Message-ID: <20161010221022.GA16060@animx.eu.org>
References: <57F6DF18.40703@yandex.ru>
 <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
 <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(CCs trimmed)

Anthony Youngman wrote:
> 
> 
> On 07/10/16 18:44, Dark Penguin wrote:
> >
> >I actually wanted to ask about that. Can you really ddrescue a drive
> >with a "hole" in it, re-add it and expect it to work?.. What happens if
> >you try to read from that "hole" again? And while I'm talking about
> >re-adding, when does it become impossible to "re-add" a drive?..
> 
> If you want to do some kernel development work, this is something
> you can do something about :-)
> 
> ddrescue creates a log of sectors that failed to copy. I've been
> thinking a bit about this, not least because other people have
> mentioned it.

I've done disk rescues where I work and I came up with an idea to use the
device mapper targets to emulate this.  Why not just read the .log file and
create a mapping where if it's good, it goes to the disk, if bad, it goes to
error.  It obviously won't handle writes, but you can layer a snapshot
device on top of it.  When the "error" is corrected, it'll write to the
snapshot.  You can then tear everything down, and merge the snapshot into
the disk.  I tried something similar when I had a bad sector on a drive and
md kept kicking it out.  Fortunately it was in /usr and wasn't important.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
