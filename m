From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Replacing a RAID 1 array
Date: Wed, 24 Apr 2002 08:16:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424121605.GA5543@willow.seitz.com>
References: <20020424120746.33046.qmail@web13707.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020424120746.33046.qmail@web13707.mail.yahoo.com>
To: Dovli X <the_dovlets@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 24, 2002 at 05:07:46AM -0700, Dovli X wrote:
> Will that work? Is there another way to do that? I
> need your help

What I would do is:

1) Backup
2) Remove current /dev/hdg
3) Install new 60G drive as /dev/hdg
4) Create new array with /dev/hde as failed disk
5) Copy everything from /dev/md0 to /dev/md1
6) replace /dev/hde

mdadm probably has some super-slick way of doing the above that I don't
know about because I haven't used it enough yet.

Ross
