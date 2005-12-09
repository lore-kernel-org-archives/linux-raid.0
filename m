From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm source rpm build error + command-line parsing error + resync
 reporting problem
Date: Fri, 9 Dec 2005 16:55:06 +1100
Message-ID: <17305.7226.5007.891700@cse.unsw.edu.au>
References: <4399198D.5050206@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Hardy on Thursday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 8, mhardy@h3c.com wrote:
> 
> Not really on-topic, but has anyone else gotten ext2online to work? I
> get this "Dec  8 21:27:02 istanbul kernel: JBD: ext2online wants too
> many credits (2050 > 2048)" after letting it attempt to extend the FS to
> cover the entire device.

I haven't used ext2online myself, but I believe that there are some
aspects of the filesystem that it is not able to resize, and you have
to have created your filesystem with the understanding that you might
want to grow it later.
 From the mkfs.ext3 man page:

       -E extended-options
 ...
                   resize=max-online-resize
                          Reserve  enough  space  so  that  the  block   group
                          descriptor  table  can  grow to support a filesystem
                          that has max-online-resize blocks.


Not a very desirable situation, but just part of the legacy that
ext2/3 brings with it.

So this time when you mkfs your new arrays, plan for growth :-)

NeilBrown
