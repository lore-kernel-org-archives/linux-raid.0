From: Derek Vadala <derek@cynicism.com>
Subject: Re: Raidstop /dev/md0 won't work
Date: Thu, 2 May 2002 14:52:05 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0205021450480.18460-100000@gecko.roadtoad.net>
References: <3CD1AF20.45E85EC8@cognigencorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3CD1AF20.45E85EC8@cognigencorp.com>
To: linux-raid@vger.kernel.org
Cc: Scott Walter <walter@cognigencorp.com>
List-Id: linux-raid.ids

On Thu, 2 May 2002, Scott Walter wrote:

> this is probably a very dumb question.. however I am not able to
> raidstop my raid-array using, which i need to do before running
> raidreconf.
> 
> %> raidstop /dev/md0
> /dev/md0: Device or resource busy.
> %>

try doing fuser -m on /dev/md0 to see which processes are using it... 

# fuser -m /dev/md0
/dev/md0:             8685c

then us ps to figure out what's up
---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

