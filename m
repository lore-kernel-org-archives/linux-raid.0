From: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Subject: Re: NFS and /dev/mdXpY
Date: Thu, 22 Apr 2010 15:47:30 -0400
Message-ID: <1271965650.593.21.camel@localhost.localdomain>
References: <20100417195747.5fae8834.stealth@sourcemage.org>
	 <20100422182543.GB8858@fieldses.org>
	 <20100422225310.38e37038.stealth@sourcemage.org>
	 <20100422193236.GA10302@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100422193236.GA10302-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Vlad Glagolev <stealth-L+UJwxqiw56VyaH7bEyXVA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Thu, 2010-04-22 at 15:32 -0400, J. Bruce Fields wrote: 
> On Thu, Apr 22, 2010 at 10:53:10PM +0400, Vlad Glagolev wrote:
> > On Thu, 22 Apr 2010 14:25:43 -0400
> > "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> > 
> > > On Sat, Apr 17, 2010 at 07:57:47PM +0400, Vlad Glagolev wrote:
> > > > Well, hello there,
> > > > 
> > > > Posted it on linux-kernel ML also, and post it here, for more specific analysis.
> > > > 
> > > > I faced this problem today while trying to mount some NFS share on OpenBSD box.
> > > > I mounted it successfully without any visible errors, but I wasn't able to cd there, the printed error was:
> > > > 
> > > > ksh: cd: /storage - Stale NFS file handle
> > > > 
> > > > Apropos, the partition is 5.5 TB. I tried another one on my box and it was mounted successfully. It was possible to manage files there too. Its size is ~3GB.
> > > > That's why the first time I thought about some size limitations of OpenBSD/Linux/NFS.
> > > > 
> > > > While talking on #openbsd @ freenode, I discovered this via tcpdump on both sides:
> > > > 
> > > > http://pastebin.ca/1864713
> > > > 
> > > > Googling for 3 hours didn't help at all, some posts had similiar issue but either with no answer at all or without any full description.
> > > > 
> > > > Then I started to experiment with another Linux box to kill the possible different variants.
> > > > 
> > > > On another box I also have nfs-utils 1.1.6 and kernel 2.6.32. Mounting that big partition was unsuccessful, it got just stuck. On tcpdump I've seen this:
> > > 
> > > I'm a bit confused.  What kernel and nfs-utils version is running on the
> > > problematic Linux server?
> > 
> > same. nfs-utils 1.1.6 and kernel 2.6.32.
> 
> Huh.  That should be new enough for it to be using uuid's.  I wonder why
> it isn't?

What are the contents of /dev/disk/by-uuid?

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
