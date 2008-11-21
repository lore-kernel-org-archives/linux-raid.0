From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [OT] If RAID's not backup... what do you use?
Date: Fri, 21 Nov 2008 04:33:06 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811210432350.1317@p34.internal.lan>
References: <49267F25.4080806@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49267F25.4080806@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 21 Nov 2008, John Robinson wrote:

> I currently have a 3x1TB RAID-5 array. It contains backups of my other 
> machines, taken with rsync. It's my central filestore, rsync'ed locally so I 
> have previous editions. It also holds my media archive, and in particular my 
> music collection that I really don't want to have to rip again. So while part 
> of it is backup for other systems, part of it needs backed up. I'd like some 
> means of coping with fire or theft of the server. I want something with some 
> room to expand, which can do the whole job unattended. So what would the 
> storage professionals here recommend? Tape autoloaders big enough to cope 
> with >2TB seem stunningly expensive to me; even the tapes are as expensive 
> per GB as hard drives...

The cheapest method?

Create another host, rsync + tar daily to the other host with the same 
configuration.

Justin.
