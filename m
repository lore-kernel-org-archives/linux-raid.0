From: Raz <raziebe@gmail.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Wed, 20 May 2009 01:27:46 +0300
Message-ID: <5d96567b0905191527m7ca74300mafb108ed14dc62c3@mail.gmail.com>
References: <1241300764.5607.36.camel@raz> <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: raz ben yehuda <raziebe@013.net>, neilb@suse.de, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, yaronp@bitband.com, Ofer Kruzel <ofer@bitband.com>
List-Id: linux-raid.ids

On Tue, May 19, 2009 at 9:09 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Sat, May 2, 2009 at 2:46 PM, raz ben yehuda <raziebe@013.net> wrot=
e:
>> Neil Hello
>> The bellow is the raid0 grow code.I have decided to fix raid0 and no=
t
>> perform the transformation raid0-raid4-raid0 due to two reasons:
>> 1. raid0 zones. this patch support any zone transformations.
>> 2. Undesired dependency of raid0 over raid4 re-striping code.
>
> Hi Raz,
>
> Can you explain a bit more about why the raid4 approach is
> undesirable? =A0I think making reshape only available to raid0 arrays
> where all the members are the same size is a reasonable constraint.

1. Because this is the general case. what will you tell a user with two=
 zones ?
2. In my next generation systems, raid0 is on top of 12 raid5s.
    A user may choose to expand one of these raid5s separately.
3. The $/Giga ratio will not decline while it should.
    Storage lasts years, disks  change sizes and formation. Segate
just announced a 2TB disk.
    If you start with 4 1TB disks, and in for 4 years you expand this
array 4 times, each time
    with a 2TB  disk, you end up with 8 TB  out of 12 TB.  You lose
30% storage. Tell that to your
    marketing and tell me when you do that, I want to see :)
4. Number of raid components .
     To reach Size X , you need more components with equal size.Having
multiple zones lets you increase
    the raid size without being subordinate to an ever increasing
number of disks. you just mirror one of the   disks to a bigger disk,
put the new disk back in the array, and reshape with the extra space
of the new disk.

Note !
I do not know what is your code base, but if you still have the hash
spacing, you might
have two zones even if the underlying components are the same in size.
So, in this case your decision if to support or not support the raid0
reshape is not just nb_zone > 1.

Other than that, if you do this work, it be will nice to have my back
covered  sooner than expected.(as long as you will NOT reach for your
revolver.... :) )

> We then get the nice benefit of reusing the raid5 reshape
> infrastructure. =A0In other words I am not convinced that the benefit=
s
> of reimplementing reshape in raid0 outweigh the costs.
> Thanks,
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
