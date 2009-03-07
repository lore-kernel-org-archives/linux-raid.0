From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm ntfs-3g
Date: Sat, 7 Mar 2009 20:49:25 +1100 (EST)
Message-ID: <580060ee8130ec857a6959ab50ee8918.squirrel@neil.brown.name>
References: <e7c6e7680903061206h43a8a278g1432ae84a124b7c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e7c6e7680903061206h43a8a278g1432ae84a124b7c0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony debeus <anthony.debeus@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, March 7, 2009 7:06 am, Anthony debeus wrote:
> Sorry if this counts as a cross-post, I posted this comment on
> http://neil.brown.name/blog/20040607123837, but perhaps emailing was
> the best route to get help. Here's the problem/question:

I do generally prefer Email, though I usually reply to comments
on my blog.

This one I answered about an hour after you sent the email.
My reply is below.

NeilBrown

Re: mdadm
=========

hda1 is 61440561K sectors in size (I think).
The NTFS filesystem is 61440560K in size.

You told mdadm to use a chunk size of 64K.  This rounds the size down to a
multiple of 64K which will be 61440512K.  Clearly too small.

Chunksize is not meaningful for RAID1.  simply remove the "-c 64"  or make
it something that divides into the filesystem size such as "-c 16".

Then it should "just work".

You should be aware that when using -B, md is not able to record device
failures.  So if one device gets unplugged, md will continue to write to
the other but will not record anywhere that the device
is failed.  If you then shutdown and start up again having plugged the
drive back in, md (or windows)
will find the other drive and assume it is a working part of the array and
will trust the data on it.  This might not be what you want.

So it will work, but be careful if you get a drive failure.


