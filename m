From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: RAID-6 support in kernel?
Date: Mon, 3 Jun 2002 15:53:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020603195324.GA11678@willow.seitz.com>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1023125615.1051.1283.camel@peecee>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>         > It'll waste 9 drives, giving me a total capacity of 7n instead of 14n. 
>         > And, by definition, RAID-6 _can_ withstand _any_ two-drive failure.
>         
>         This is certainly not true. 
>         
>         Combining N RAID-5 into a stripe wastes on N disks. 
> 
> Hot spares are quite a nice way to increase the reliability of your
> arrays, somewhat.  You can still be in trouble if a second disk fails
> before the resync finishes, but at that point you're probably talking
> about something of a more catastrophic failure, perhaps outside of the
> machine itself.  

This could become a lot less of an issue.  I recall Neil Brown recently
mentioning that he was thinking about journalling RAID code.  This would
do away with long resyncs much like journalling filesystems did away
with long fscks.  Obviously, I'm not sure if it's something he'll
decide to do or not, but it would really increase the viability of hot
spares.

Ross Vandegrift
ross@willow.seitz.com
