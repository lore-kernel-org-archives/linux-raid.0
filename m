From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: polishing up mdadm manpages: mdassemble(8), mdmon(8)
Date: Thu, 10 Mar 2011 13:57:29 +0000
Message-ID: <a5e41cc2828ecc385314e30988be9b7d@imap.dd24.net>
References: <daeaad7c9ff2fa76529ad5b58994ba3e@imap.dd24.net> <20110310161827.6df62c7a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110310161827.6df62c7a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Mar 2011 16:18:27 +1100, NeilBrown <neilb@suse.de> wrote:
> Of course I could create the patch my - it looks like you 
> start from the verison in the 3.2 release - correct?
Yes.


> Being consistent is good, but using \fB \fI etc is not.
> Convention (as I understand it) prefers .B .I etc.
Is this convention? I've seen many manpages using it,.. and it seems to be
part of the standard format?

> There are a variety of programs around which convert man pages to
> other formats and I trust the ".B" tags to be handled more reliably.
Well if they don't handle \f* they should be fixed IMHO....

Anyway,.. the reason for me arguing so strong agains .B .I etc. is that it
really makes the (raw) manpage nearly unreadable/unmaintainable IMHO.
Especially polishing up everything is made rather impossible so (IMHO)...
so do you insist on this?.


> Maybe... The ".pid" and ".sock" are file name extensions.  If your
change
> were made (which quite possibly improves readability) it might then me
> necessary to say something explicit about extensions.
Well that's up to you then,.. I don't have enough knowledge about the
containers to do that =)


Cheers,
Chris.
