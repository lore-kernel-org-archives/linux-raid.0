From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 19:48:12 +0100
Message-ID: <877i2mk6qb.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<20090318121825.GL32416@skl-net.de> <49C0EA5F.9070901@vshift.com>
	<20090318123525.GK17185@skl-net.de>
	<87wsam53ev.fsf@frosties.localdomain>
	<20090318142653.GA15321@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318142653.GA15321@cthulhu.home.robinhill.me.uk> (Robin
	Hill's message of "Wed, 18 Mar 2009 14:26:53 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill <robin@robinhill.me.uk> writes:

> You could do this via the new RAID5-RAID6 migration. Either:

Oh, someone is working on that. Didn't know that. That certainly makes
3 disk raid6 less important as one can go via raid5 then.

But still. If it is only that one line in the kernel that checks < 4
instead of < 3 then ...

MfG
        Goswin
