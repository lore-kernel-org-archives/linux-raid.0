From: "Andre' Breiler" <andre.breiler@null-mx.org>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 03:43:28 +0000 (GMT)
Message-ID: <Pine.LNX.4.33.0601200326590.17229-100000@pegasus.teamwerk.com>
References: <43D09671.3010405@reub.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D09671.3010405@reub.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Fri, 20 Jan 2006, Reuben Farrelly wrote:

> On 20/01/2006 11:32 a.m., Neil Brown wrote:
> >
> > The in-kernel autodetection in md is purely legacy support as far as I
> > am concerned.  md does volume detection in user space via 'mdadm'.
>
> Hrm.  <puzzled look>   How would I then start my md0 raid-1 array that is
> mounted as the root partition / if I'm not doing this when the kernel is
> starting up?  Because without it I've got no userspace to actually execute.

Indeed you won't be able to use a 'plain kernel' anymore but switch to
kernel + initrd.
This adds a good amount of useful flexibility (but makes life a little bit
harder).

The autodetect feature got discussed multiple time with pro/cons for it
(so I will skip it there) with the overall outcome that it's a to
dangerous feature to leave in kernel space (btw. on some architectures
it doesn't work at all anyway) in the long term.

> Some of the other arrays with things like /var and /home could obviously be
> easily assembled soon after the kernel hands over control to userspace before
> the filesystem points are mounted, but for the root I am not quite sure
> how it
> could work...

A simple initrd. If you look at random distributions (e.g. Debian) you
will see it done that way (yes I don't think it's perfect as it is yet).

Personally on systems which change often I run without auto detect.
On systems which hardly change and if get wiped disks I use the
autodetection.

Andre'

