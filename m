From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Partitioned raid and major number
Date: Tue, 2 Mar 2004 00:36:15 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c20ktv$37o$1@terminus.zytor.com>
References: <20040225145624.GA1513@cistron.nl> <20040228010916.GC13404@drinkel.cistron.nl> <16450.35269.770163.948225@notabene.cse.unsw.edu.au> <20040301010419.GK14194@drinkel.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040301010419.GK14194@drinkel.cistron.nl>
By author:    Miquel van Smoorenburg <miquels@cistron.nl>
In newsgroup: linux.dev.raid
> 
> POSIX allows different semantics for / and //, I mentioned before that
> perhaps we should make "cd //" chdir to rootfs instead of /. Then
> you can also have //proc and //sys without explicitly mounting them.
> But I don't think the time has come for that yet (besides it needs
> more thought wrt namespaces, chroot etc).
> 

It's allowed, but definitely not recommended.

I do like the idea of making rootfs remountable, though.

> > Another is to add "rootdev" to /proc/*, as in appended patch. Then
> >   ln -s /proc/self/roodev /dev/root
> > 
> > and providing /proc is mounted, /dev/root will work.
> 
> I like that approach.

.. assuming the rootfs isn't a nodev filesystem.

	-hpa
