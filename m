From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 02:04:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040301010419.GK14194@drinkel.cistron.nl>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net> <20040228010916.GC13404@drinkel.cistron.nl> <16450.35269.770163.948225@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16450.35269.770163.948225@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Mon, Mar 01, 2004 at 01:54:29 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 01 Mar 2004 01:54:29, Neil Brown wrote:
> On Saturday February 28, miquels@cistron.nl wrote:
> > 
> > Hmm. With a dynamic major, the system might fail at checking the root
> > file system at boot. At that time, /dev is still read-only, and
> > /dev/md/d0p1 might not be the correct device yet.
> > 
> > So either mdp needs its own partition number, or we need a /dev/root
> > device that's an alias for the current root (like /dev/console).
> > 
> 
> Yes, I think this is a real problem.
> There are a number of avenues that could be followed to fix it.
> One it your suggestion.

That was a quick hack and as I said, I think it's flawed :)

> Another is to make "rootfs" remountable like this:

POSIX allows different semantics for / and //, I mentioned before that
perhaps we should make "cd //" chdir to rootfs instead of /. Then
you can also have //proc and //sys without explicitly mounting them.
But I don't think the time has come for that yet (besides it needs
more thought wrt namespaces, chroot etc).

> Another is to add "rootdev" to /proc/*, as in appended patch. Then
>   ln -s /proc/self/roodev /dev/root
> 
> and providing /proc is mounted, /dev/root will work.

I like that approach.

Mike.
