From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Software raid, booting and bios
Date: Sat, 21 May 2011 05:52:19 +0800
Message-ID: <4DD6E293.8000503@wasp.net.au>
References: <9067914580344941270@unknownmsgid>	<ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu> <ir5ci1$uc6$1@dough.gmane.org> <4DD65A66.5030904@turmel.org> <ir62p0$b5o$1@dough.gmane.org> <4DD6C1EB.1030907@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD6C1EB.1030907@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/05/11 03:32, Phil Turmel wrote:

> the big deal is the lack of moving parts:  No spindle bearing, no head positioner gear train.

Sorry, this just tickled me. "gear train" ? Which decade are we talking about? The last drive I saw 
that had any form of mechanical power transfer mechanism for head positioning was a 60MB RLL Seagate 
clunker.

Now, to add some form of use to the thread I've been using commodity CF cards in home-brew CF to ATA 
adaptors in embedded systems for 10 years. Flash is _the_ way to go for high reliability systems 
that don't have lots of write cycles.

My TV box that has no on-board PXE has been booting from a 10MB USB stick using loadlinux since 
2003. Dead reliable after ~69,000 hours power on time. I've not had a hard disk last that long since 
my old 200MB WD IDE drive (which is still running with over 100,000 hours on it).

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
