From: Alexander =?iso-8859-1?b?S/xobg==?= <alexander.kuehn@nagilum.de>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 18:02:34 +0100
Message-ID: <20111110180234.Horde.Q0tycZk8pphOvAOqm3rzJ2A@cakebox.homeunix.net>
References: <4EBBF60F.4030606@northfolk.ca>
 <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
 <4EBC00E6.3030404@northfolk.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBC00E6.3030404@northfolk.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Chris Purves <chris@northfolk.ca>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, jeromepoulin@gmail.com
List-Id: linux-raid.ids

Try --re-add.


Zitat von Chris Purves <chris@northfolk.ca>:

> On 2011-11-10 12:20, Alexander K=FChn wrote:
>> ddrescue to the rescue!
>> Get a another new disk, then ddrescue the one with the read error =20
>> to the new disk.
>> Assemble the array using the new disk instead of the one with the =20
>> read error.
>> You will loose the blocks that can't be read of course.
>> And in the future do run raid check/scrubbing at regular intervals. =
;)
>
> I have tried this already.  After cloning the disk with errors, I =20
> replaced it with the clone and tried to re-start the array using
>
> mdadm --assemble --force /dev/md1
>
> mdadm assigned the new disk as a spare and said there were only =20
> three disks to start the array and so couldn't start it.
>
> After I clone the disk with the error, how precisely should I =20
> re-start the array?
>
>
> --=20
> Chris Purves
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
