From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: assemble vs create an array.......
Date: Thu, 06 Dec 2007 11:12:05 -0600
Message-ID: <47582D65.4000808@sandeen.net>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com> <475552D2.4000802@mpigani.org> <47568DE1.1050108@dgreaves.com> <4758129D.40600@mpigani.org> <475825C0.4070605@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <475825C0.4070605@msgid.tls.msk.ru>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Dragos <dragos@mpigani.org>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Michael Tokarev wrote:

> It's sad that xfs refuses mount when "structure needs
> cleaning" - the best way here is to actually mount it
> and see how it looks like, instead of trying repair
> tools.  Is there some option to force-mount it still
> (in readonly mode, knowing it may OOPs kernel etc)?

depends what went wrong, but in general that error means that metadata
corruption was encountered which was sufficient for xfs to abort
whatever it was doing.  It's not done lightly; it's likely bailing out
because it had no other choice.

You can't "force mount" something which is sufficiently corrupted that
xfs can't understand it anymore...  IOW you can't traverse and read
corrupted/scrambled metadata, no mount option can help you.  :)

If the shutdown were encountered during use, you could maybe avoid the
bad metadata.  If it's during mount that's probably a more fundamental
problem.

kernel messages when you get the "structure needs cleaning" error would
be a clue as to what it actually hit.

-Eric
