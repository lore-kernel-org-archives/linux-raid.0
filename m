From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 01:17:52 +0200
Message-ID: <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.51121.178492.61143@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> You shouldn't need to upgrade kernel

Ok.
I had a crazy idea that 2 devices down in a RAID5 was an MD bug.

I didn't expect MD to kick that last disk - I would have thought that
it would just pass on the read error in that situation.  If you've got
the time to explain I'd like to be wiser - why not?

> But yet, use --assemble --force and be aware that there could be data
> corruption (without knowing the history it is hard to say how
> likely).  An 'fsck' at least would be recommended.

Thanks a tera!

(Probably no corruption since I was strictly reading from the array
when the disks were kicked.)
