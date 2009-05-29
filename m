From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Upgrading a software RAID
Date: Fri, 29 May 2009 10:58:16 +0200
Message-ID: <20090529085815.GA13854@rap.rap.dk>
References: <4A1EA095.9090406@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A1EA095.9090406@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Cc: robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 28, 2009 at 10:32:53AM -0400, Maxime Boissonneault wrote:
>
> Robin Hill a =E9crit :
>> On Mon May 25, 2009 at 01:05:15PM -0400, Maxime Boissonneault wrote:
>>
>>  =20
>>> Hello,
>>> I am using Ubuntu Hardy with 3x500GB drives and the following RAID
>>> configuration :
>>>
>>> /boot is on a 100MB RAID1
>>> / is on a 30GB RAID0
>>> /home is on a 906GB RAID5
>>>
>>>    =20
>> Ouch - why RAID0 for /?  If you lose a single drive then all the
>> configuration, etc. is down the drain.  I'd suggest rethinking this
>> while you're going through the rebuild process anyway.
>>
>>  =20
> That is why I do backups of / on /home regularily. I first did a RAID=
0 =20
> for performance. I did some testing on performance of RAID0,1,5 and =20
> RAID1 was pretty lousy (I put the results of my tests here : =20
> http://cqed.physique.usherbrooke.ca/~mboisson/htpc.php?sec=3Draid_tes=
t )
> I guess I should have used a RAID5, but RAID1 seems like a terrible i=
dea =20
> considering the really bad performances.

Hmm, why not use raid10,f2 for the / system?
Then you will get almost raid0 read performance, while write performanc=
e
is about half of raid0.

A setup is described in
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

You can do the / system with raid10,f2 with just 2 disks.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
