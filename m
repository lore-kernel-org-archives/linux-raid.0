From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: Resize on dirty array?
Date: Wed, 09 Aug 2006 16:56:53 +0200
Message-ID: <44D9F7B5.1060000@idgmail.se>
References: <44D7DC93.2070905@net1plus.com>	<17623.57067.835826.446152@cse.unsw.edu.au>	<44D8E535.9080208@net1plus.com> <17625.24594.568139.430440@cse.unsw.edu.au> <44D9C6F5.7070501@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D9C6F5.7070501@net1plus.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Peverill wrote:

> I'll try the force assemble but it sounds like I'm screwed.  It 
> sounds like what happened was that two of my drives developed bad 
> sectors in different places that weren't found until I accessed 
> certain areas (in the case of the first failure) and did the drive 
> rebuild (for the second failure).

The file /sys/block/mdX/md/sync_action can be used to issue a recheck of
the data. Read Documentation/md.txt in kernel source for details about
the exact procedure. My advice (if you still want to continue using
software raid) is that you run such a check before any add/grow or other
action in the future. Also, if the raid has been unused for a long while
it might be a good idea to recheck the data.

[snip]

I feel your pain. Massive data loss is the worst. I have had my share of
crashes. Once due to bad disk and no redundancy, the other time due to
good old stupidity.

Henrik Holst
