From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Problems with raidreconf and RAID-5
Date: Mon, 2 Sep 2002 15:25:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020902132505.GK7496@unthought.net>
References: <3D64C87D.5809A077@mbnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D64C87D.5809A077@mbnet.fi>
To: Mikko Saukkoriipi <Mikko.Saukkoriipi@mbnet.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 22, 2002 at 02:18:21PM +0300, Mikko Saukkoriipi wrote:
>   I have been testing raidreconf and I've been able to add a new disk=
 to
> a RAID-0 array, but trying to convert RAID-0 to RAID-5 or add a new d=
isk
> to RAID-5 have failed.

I see that your disks are not of equal size - I have seen one other
report of problems with the RAID-5 driver (in reaidreconf - not the
kernel RAID-5 driver) related to disks of different sizes.

>   Just before the conversion has finished or some times even at
> beginning I get and error "raid5_map_global_to_local: disk 0 block ou=
t
> of range: 488098 (487840) gblock =3D 1464296" or similar and raidreco=
nf
> aborts.

Yep - very similar to that other report.

>   I'll add below script of the program running as well the used raidt=
abs
> and listings of partitiontables. The example is from adding a new dis=
k
> to a 3 drive RAID-5 array. raidreconf version is "raidreconf 0.1.1 fo=
r
> mkraid version 0.90.0".

Great - thanks

>=20
> Also, what file is gmon.out? It appears after running raidreconf, but
> the documentation didn't mention anything about it.

That's profiling output - because raidreconf (for some reason) was
compiled with the -pg switch for gcc.

You can run "gprof raidreconf" and see which routines take up the most
CPU time   :)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
