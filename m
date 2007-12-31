From: "Marc MERLIN" <marc@merlins.org>
Subject: Re: Last ditch plea on remote double raid5 disk failure
Date: Mon, 31 Dec 2007 13:40:08 +0100
Message-ID: <8e0f3ba80712310440k56981fcfyf28e01870d33be3@mail.gmail.com>
References: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com>
	 <18296.56100.769123.555100@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18296.56100.769123.555100@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Dec 31, 2007 1:05 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 31, merlin@gmail.com wrote:
> >
> > I'm hoping that if I can get raid5 to continue despite the errors, I
> > can bring back up enough of the server to continue, a bit like the
> > remount-ro option in ext2/ext3.
> >
> > If not, oh well...
>
> Sorry, but it is "oh well".
>
> I could probably make it behave a bit better in this situation, but
> not in time for you.

Understood, thanks much for the answer, I'll work on moving services
to another server now.

If that's a reasonable RFE for the people concerned, it'd be nice to
have a non default md raidtab option, or an assemble option that says
"continue as long as you can if kicking another drive will disable the
array", I'd still be ok with the array staying read-write if block
errors are passed through since the underlying filesystem would
remount read only by itself. I think it my case, it would have allowed
me to reboot my system with md5 damaged, limping on one drive fewer,
having the lvm be read-write, and the /usr partition within it be
read-only while /var within the same raid5 md, same LVM VG but
different LV, could stay read-write.

That might be a bit too much of wishful thinking though. Even having
everything still run as read-only (again, as a non default option),
would be nice. No idea how hard or unrealistic that is, but just
throwing the idea out :)

Either way, have a great new year.

Best,
Marc
