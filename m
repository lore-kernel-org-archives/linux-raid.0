From: "NeilBrown" <neilb@suse.de>
Subject: Re: internal write-intent bitmap, chunksize, superblock
Date: Sun, 24 May 2009 07:07:55 +1000 (EST)
Message-ID: <6a621b117f3d7dc76c4cf5c9b64496ab.squirrel@neil.brown.name>
References: <1243089267.5740.39.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243089267.5740.39.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 24, 2009 12:34 am, Redeeman wrote:
> Hello.
>
> I have just created a raid6 array with 8 1tb drives, and it uses the
> default metadata 0.9.
>
> I have been reading up on write intent bitmaps, and i wish to create an
> internal one. I read about different chunk sizes yielding different
> performance costs, but one thing i wonder is, how much space is reserved
> in the superblock for the bitmap? and what happens if i try to create a
> bitmap which would take more than the reserved space?

60K.
It won't let you.


NeilBrown

