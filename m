From: Derek Vadala <derek@cynicism.com>
Subject: Re: mkraid to mdadm conversion?
Date: Wed, 7 May 2003 12:02:16 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030507160216.7F5FC3B84A@jaded.cynicism.com>
References: <3EB9245E.2020901@cc.kuleuven.ac.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB9245E.2020901@cc.kuleuven.ac.be>
To: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.ac.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 May 2003, Herta Van den Eynde wrote:

> First of all, is there any documentation on mdadm other than the man
> pages?  I currently have 2 systems with raid devices set up using the
> mkraid, and would like to know what I'd need to do to convert them to mdadm.

The man pages (and supporting docs) are comprehensive. If you are not
finding something in the man page for madm try looking at the manual pages
for mdadm.conf(5) and md(4). You might also want to look in
/usr/share/doc/mdadm for some additional info.

There's also this O'Reilly Network article (*cough*):
http://linux.oreillynet.com/pub/a/linux/2002/12/05/RAID.html

You don't need to 'convert' your arrays. You can just begin using mdadm to
manage existing arrays, assuming you are working with current versions of
all the tools and the md driver. Simply stop using raidtools and
/etc/raidtab. If your arrays are not set to autostart, you will have to
edit your init scripts to call mdadm and activate arrays much in the same
way that raidstart would have been called.

The best place for you to start is looking at how to generate an
/etc/mdadm.conf from your existing arrays. This is well docummented in the
texts cited above.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

