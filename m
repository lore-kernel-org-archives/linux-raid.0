From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 11:49:09 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402191118090.10623-100000@praktifix.dwd.de>
References: <20040218214840.GS20790@datavibe.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040218214840.GS20790@datavibe.net>
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 Feb 2004, Rev. Jeffrey Paul wrote:

> 
> I'm building an nfs server to export home directories to a few login 
> servers used somewhat heavily by a few hundred people.  Additionally, on 
> the array will be a bunch of web content and mysql data files.
> 
> I'm currently thinking of a few different configurations, all using four
> drives in the 180-250gb range.  I could get sata or udma drives, i could
> go raid5 or raid10, and i could do this in linux software raid (using,
> say, a pair of promise ultra100s to give me four udma ports, or with an
> SATA card), using 3ware's UDMA four-port escalade, or with 3ware's new
> sata escalade.
> 
> What are the compelling reasons for using sata over udma?
>
For now none, really. Only that in future it will be more and more difficult
to get UDMA drives. But this might take a long time before this really
becomes a problem. SATA II will bring a real advantage.

> I've had really good experiences with linux software raid, but always
> in small workgroup or personal file servers.  I'm wondering if this sort
> of big, random, heavy load will drag down an otherwise speedy box.
>
I have a system running for nearly three years distributing some 2.3 million
files with 200GB daily. This is with linux software raid and have encountered
absolutly no problems. During the same period another system (not linux) with
a similar workload but with hardware raid has failed twice, once makeing
all data useless.

> Is it worth it to just drop the extra $300 and go with hardware raid?
>
In my opinion no. Most of the cheaper hardware raids are really just
software raid solutions. For the more expansive once always remember
you will always need drivers and there is no guarentee that you
will get them in two or three years. Some vendors do no longer exist
or no longer support that product.

Also don't worry about the slightly higher CPU usage of software raid.
The time spend by most application is by waiting for IO from disk/raid,
so any time gained here (software raid is faster then hardware raid) will
easily make up the lost CPU time.

Regards,
Holger

