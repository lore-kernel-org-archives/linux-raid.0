From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: USB raid5?
Date: Tue, 30 Nov 2004 07:51:54 -0600
Message-ID: <6d5bedd8041130055139423510@mail.gmail.com>
References: <41AC11CF.2050102@pobox.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41AC11CF.2050102@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Nov 2004 00:23:11 -0600, Michael Stumpf <mjstumpf@pobox.com> wrote:
> In the interminable battle with physical arrangement & rack space, has
> anyone tried arrays of "external" usb 2.0 or firewire connected drives?
> 
> Are there limitations to size, or to bandwidth that aren't obvious, that
> make this a non desirable solution?

Am currently running a RAID-5 array that has two internal drives and
two external firewire drives. Bandwidth is good enough for doing hour
long plus video captures with no dropped frames, and to playback video
and audio with no drops or stutters.

USB 2 appears to offer similar bandwidth, but at the expense of more
CPU overhead - which may or may not be an issue depending on your
configuration.

In either case, you're more likely going to have a problem getting
your Linux system to recognize the external drive than in using it as
part of an array.

YMMV, IANAL, etc.
