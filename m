From: Phil Turmel <philip@turmel.org>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Sun, 5 Mar 2017 13:55:22 -0500
Message-ID: <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Olivier Swinkels <olivier.swinkels@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/03/2017 04:35 PM, Olivier Swinkels wrote:
> Hi,
> 
> I'm in quite a pickle here. I can't recover from a disk failure on my
> 6 disk raid 5 array.
> Any help would really be appreciated!
> 
> Please bear with me as I lay out the the steps that got me here:

[trim /]

Well, you've learned that mdadm --create is not a good idea. /-:

However, you did save your pre-re-create --examine reports, and it
looks like you've reconstructed correctly.  (Very brief look.)

However, you discovered that mdadm's defaults have long since changed
to v1.2 superblock, 512k chunks, bitmaps, and a substantially different
metadata layout.  In fact, I'm certain your LVM metadata has been
damaged by the brief existence of mdadm's v1.2 metadata on your member
devices.  Including removal of the LVM magic signature.

What you need is a backup of your lvm configuration, which is commonly
available in /etc/ of an install, but naturally not available if /etc/
was inside this array.  In addition, though, LVM generally writes
multiple copies of this backup in its metadata.  And that is likely
still there, near the beginning of your array.

You should hexdump the first several megabytes of your array looking for
LVM's XML formatted configuration.  If you can locate some of those
copies, you can probably use dd to extract a copy to a file, then use
that with LVM's recovery tools to re-establish all of your LVs.

There is a possibilility that some of your actual LV content was damaged
by the mdadm v1.2 metadata, too, but first recover the LVM setup.

Phil
