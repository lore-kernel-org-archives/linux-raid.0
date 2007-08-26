From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Patch for boot-time assembly of v1.x-metadata-based soft (MD)
 arrays
Date: Sun, 26 Aug 2007 09:46:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708260946040.26771@p34.internal.lan>
References: <619968.4419.qm@web33607.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <619968.4419.qm@web33607.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Abe Skolnik <abe_skolnik@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids



On Sun, 26 Aug 2007, Abe Skolnik wrote:

> Dear Mr./Dr./Prof. Brown et al,
>
> I recently had the unpleasant experience of creating an MD array for
> the purpose of booting off it and then not being able to do so.  Since
> I had already made changes to the array's contents relative to that
> which I cloned it from, I did not want to reformat the array and
> re-clone it just to bring it down to the old 0.90 metadata format so
> that I would be able to boot off it, so I searched for a solution, and
> I found it.
>
> First I tried the patch (written by Neil Brown) which can be seen at...
>  <http://www.issociate.de/board/post/277868/>
>
> That patch did not work as-is, but with some more hacking, I got it
> working.  I then cleaned up my work and added relevant comments.
>
> I know that Mr./Dr./Prof. Brown is against in-kernel boot-time MD
> assembly and prefers init[rd/ramfs], but I prefer in-kernel assembly,
> and I think several other people do too.  Since this patch does not
> (AFAIK) disable the init[rd/ramfs] way of bringing up MDs in boot-time,
> I hope that this patch will be accepted and submitted up-stream for
> future inclusion in the mainline kernel.org kernel distribution.
> This way kernel users can choose their MD assembly strategy at will
> without having to restrict themselves to the old metadata format.
>
> I hope that this message finds all those who read it doing well and
> feeling fine.
>
> Sincerely,
>
> Abe Skolnik
>
> P.S.  Mr./Dr./Prof. Brown, in case you read this:  thanks!
>      And if you want your name removed from the code, just say so.
>

> but I prefer in-kernel assembly,
> and I think several other people do too.
I concur with this statement, why go through the hassle of init[rd/ramfs] 
if we can just have it done in the kernel?

Justin.
