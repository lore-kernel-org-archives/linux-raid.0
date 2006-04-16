From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 01:36:25 +0200
Message-ID: <62b0912f0604161636w391ed66bu45ac3231b26b8dcb@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
	 <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
	 <17474.54168.331725.412456@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.54168.331725.412456@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> It is arguable that for a read error on a degraded raid5, that may not
> be the best thing to do, but I'm not completely convinced.  A read
> error will mean that a write to the same stripe will have to fail, so
> at the very least we would want to switch the array read-only.

That would be much nicer for me as a user, because:
 * I would know which disks are the freshest (the ones marked U).
 * My data wouldn't be abruptly pulled offline - right now I'm getting
*weird* errors from the systems on top of the array.
 * I wouldn't have to try and guess the correct 'mdadm' command to
stop/start the array (including pointing at the right disks).

2 cents ;).

Thanks for the explanation.
