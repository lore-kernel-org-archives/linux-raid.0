From: Julian Cowley <julian@lava.net>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 00:53:07 -1000 (HST)
Message-ID: <alpine.LRH.2.00.0902120003100.3470@taurus.cesta.com>
References: <20090212031009.23983.14496.stgit@notabene.brown> <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com> <20090212094604.GA11981@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1094716015-36599213-1234433017=:3470"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212094604.GA11981@rap.rap.dk>
Content-ID: <alpine.LRH.2.00.0902120006260.3470@taurus.cesta.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1094716015-36599213-1234433017=:3470
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.00.0902120006261.3470@taurus.cesta.com>

On Thu, 12 Feb 2009, Keld Jørn Simonsen wrote:
> On Thu, Feb 12, 2009 at 09:13:17AM +0000, Steve Fairbairn wrote:
>> Keld Jørn Simonsen wrote:
>>>
>>> I would rather have functionality to convert raid10 to raid5.
>>> raid1 should be depreciated, as raid10,n2 for all purposes is the same
>>> but better implementation and performance, and raid10,f2 and raid10,o2
>>> are even better.  Nobody should use raid1 anymore.

Interesting.

>> Complete ignorance of raid10 here, but is raid10,<anything> bootable,
>> like raid1 is?  I use raid1 on my root and boot partitions.
>
> AFAIK, raid10,n2 in default mode (superblock etc) is bootable, as it
> looks like two copies of a normal FS. I think this was even reported
> on this list at some time.
>
> You are not the only one that does not know much about raid10. I think
> most Linux administrators don't.  And other system adminstrators most
> likely don't either.

Probably because of its name, which is too close to RAID 1+0 and therefore 
can easily be ignored in situations where RAID 1+0 normally can't be used.

I always assumed (without looking into it) that raid10 was supposed to be 
a replacement/improvement on RAID 1+0, which requires a minimum of 4 
drives.  I'd seen the wikipedia page where 3 drives are used for raid10, 
but it never occurred to me that raid10 is such a generalization that it 
could be used with just two drives.

> Maybe we should rename raid10 to raid1?

That would be a mistake, too.  It's not tied to RAID 1+0, but it's not 
tied down to RAID 1 either, and its name should reflect that.  I'd prefer 
something like raid1+0E, raid0E, raid1+1, or even just raid11.  The latter 
term is not used anywhere I know of, so it stands out.

The horse has already probably left the barn on this one, though.

Perhaps instead the documentation in mdadm(8) and md(4) could be updated 
to mention that raid10 is a combination of the concepts in RAID 1 and RAID 
0, but is generalized enough so that it can be done with just two drives 
at a minimum.  That would have caught my eye, at least.
--1094716015-36599213-1234433017=:3470--
