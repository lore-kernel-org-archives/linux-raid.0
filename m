From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: raid10 ... (was: Re: ANNOUNCE: mdadm 1.7.0)
Date: Sat, 14 Aug 2004 10:18:09 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408141014260.14853-100000@coffee.psychology.mcmaster.ca>
References: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
To: Jure =?UTF-8?Q?Pe=C3=A8ar?= <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-raid.ids

> Am i dreaming (it's well over 4am here :) ? Or is something like this
> possible? Maybe not with a md personality, but by some daemon that would be
> taking care of a dm map?

such things are available commercially; I can't say how well they work.
personally, I doubt that this kind of thing can be done well at a purely
block level - I think that some file-level information would be beneficial,
perhaps essential.  but this is a layering-violating idea, and seems to 
rub a lot of people the wrong way.  on the other hand, there is a seperate
movement towards "object storage" systems, which is certainly a related idea.

regards, mark hahn.

