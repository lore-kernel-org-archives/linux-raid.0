From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Confused about UUID mounting and mirrors
Date: Tue, 17 Jun 2008 20:17:50 +0100
Message-ID: <18520.3550.368939.664352@tree.ty.sabi.co.uk>
References: <4856A8C6.3030609@kmaclub.com>
	<4856CFE1.1020105@ziu.info>
	<4856DB4C.20905@kmaclub.com>
	<4856DD5B.9050303@dgreaves.com>
	<485721A5.3080101@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <485721A5.3080101@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... absurd question about disambiguating storage entities with
the same UUID but which are otherwise distinct ... ]

> Is anyone mounting a mirrored /boot using UUID's?

I hope it is only you, because it is a complete absurdity: UUID
stands for Universally Unique ID. If someone gives the same UUID
(for example by mirroring) to two entities that are in fact not
absolutely equivalent in every respect (including convenience)
they are misusing UUIDs (but then how many people understand the
difference between "equal" and "identically the same", even
among programmers: modality can be subtle).

In practice current storage entity naming schemes have not been
designed to cover some common cases, and you have two options:

* Use relative (storage path) names, and those will change, but
  you can distinguish between mirror copies.

* Use absolute (UUIDs, labels) names, and those won't change,
  but you cannot distinguish between mirror copies.

An approach that would be suitable for mirroring would be to use
semi-relative naming: absolute naming for the containing storage
entity (e.g. disk) and relative naming for the contained one
(e.g.  partition or filesystem), assuming that the latter are
static and not subject to change.

Then you can mirror the contained storage entities and
ambiguities do not arise because the container UUID is
unambiguous and the relative path from it is static.  For
example something like '/dev/${VOLID}_p0' where the '${VOLID}'
part can be a UUID or a storage media label or "something".

The problem is that none of the commonly available software uses
this kind of naming scheme, even if to some extend it would not
be too hard to introduce the basic outline.

I use something like that *manually* where I use the "disk
signature" (4 bytes) of a PC-DOS MBR to uniquely identify
physical volumes, and then I mirror-copy not the whole physical
volume (which would duplicate the disk signature), but each
partition defined by the MBR. I don't use 'udev' (I think it is
awful and then I dislike the ugly, petty politics surrounding
its inception).
