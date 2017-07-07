From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Linear device of two arrays
Date: Fri, 7 Jul 2017 23:20:36 +0200
Message-ID: <20170707212036.GA26305@metamorpher.de>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu>
 <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 07, 2017 at 10:26:28PM +0200, Veljko wrote:
> So my question is still, how can an existing array be added to linear
> device, and it's file system expanded over the second array.

Put LVM on top?

You could create LVM on the new array, copy your files over, then extend.

If you know LVM _really_ well, it's also possible to convert existing 
filesystems without moving data (other than relocating the parts 
occupied/unusable by LVM, i.e. one extent-size worth of data at 
start and end of disk).

Or find a way to use more than one filesystem.

> And there is also question of spare drive.

Spares can be shared/moved if you use spare-groups.

From the manpage:

| As  well  as  reporting  events,  mdadm may move a spare drive from one
| array to another if they are in the same spare-group or domain  and  if
| the destination array has a failed drive but no spares.

Regards
Andreas Klauer
