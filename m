From: Neil Brown <neilb@suse.de>
Subject: Re: Weird Issue with raid 5+0
Date: Sun, 21 Feb 2010 19:16:40 +1100
Message-ID: <20100221191640.39b68b01@notabene.brown>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	<20100221164805.5bdc2d60@notabene.brown>
	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Feb 2010 02:26:42 -0500
chris <tknchris@gmail.com> wrote:

> That is exactly what I didn't want to hear :( I am running
> 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing to
> do with my chunk/block sizes? If this is a bug what versions are
> affected, I'll build a new domU kernel and see if I can get it working
> there.
> 
> - chris

I'm absolutely sure it is a kernel bug.
I have no idea what version might be affected.  Probably all, but 
as xen isn't fully in main line it isn't easy for me to explore.

I suggest you contact the xen developers (or whoever you got xen from).
I'm happy to discuss the problem with someone who knows about xen block
device access, but I don't want to go hunting to find such a person.

NeilBrown
