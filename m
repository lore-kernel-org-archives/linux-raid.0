From: Chris Purves <chris@northfolk.ca>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 12:50:46 -0400
Message-ID: <4EBC00E6.3030404@northfolk.ca>
References: <4EBBF60F.4030606@northfolk.ca> <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Alexander_K=FChn?= <alexander.kuehn@nagilum.de>, jeromepoulin@gmail.com
List-Id: linux-raid.ids

On 2011-11-10 12:20, Alexander K=FChn wrote:
> ddrescue to the rescue!
> Get a another new disk, then ddrescue the one with the read error to =
the new disk.
> Assemble the array using the new disk instead of the one with the rea=
d error.
> You will loose the blocks that can't be read of course.
> And in the future do run raid check/scrubbing at regular intervals. ;=
)

I have tried this already.  After cloning the disk with errors, I repla=
ced it with the clone and tried to re-start the array using

mdadm --assemble --force /dev/md1

mdadm assigned the new disk as a spare and said there were only three d=
isks to start the array and so couldn't start it.

After I clone the disk with the error, how precisely should I re-start =
the array?


--=20
Chris Purves
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
