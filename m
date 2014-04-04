From: Christian Schmitz <schnet@hotmail.com>
Subject: RE: Problem Syncing raid1
Date: Fri, 4 Apr 2014 15:11:01 +0000
Message-ID: <BAY177-W16803B322FABA977594241C86F0@phx.gbl>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
 <CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>
 <BAY177-W961648C4893E888EECA18C86D0@phx.gbl>
 <CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>,<BAY177-W35793297D3F640EF11F48C86D0@phx.gbl>
 <BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
 <CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com>
 <alpine.DEB.2.02.1404041427350.10236@uplift.swm.pp.se>,<CAK_KU4YnrP4O=JCPQsTxRrOT+nXMAraiMN+_T6W96ekHpPtsTw@mail.gmail.com>,<alpine.DEB.2.02.1404041613340.10236@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404041613340.10236@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Scott D'Vileskis <sdvileskis@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

well running smartctl to disk with bad sector.
smartctl -t long /dev/sde
after finish
smartctl -a /dev/sde
=2E...
=2E...
=2E..
SMART Self-test log data structure revision number 1

# 1 extended offline completed: read failure=A0 .........=A0 LBA_of_fir=
st_error 22549777

# hdparm --read-sector 22549777 /dev/sde
i/o error
# hdparm --yes-i-know-what-i-am-doing --write-sector 22549777 /dev/sde=20

After that i can read the sector
# hdparm --read-sector 22549777 /dev/sde
0000 0000 ..... etc etc

#smartctl -a /dev/sde=20
Reallocated_Sector_Ct=A0=A0=A0=A0=A0=A0=A0=A0=A0 0

seem like sector fixed and not relocated.=20
Still the fsck.reiserfs --rebuild-tree /dev/md4 say input-output error,=
 so i am searching for more bad sectors.

I know what is the bad sector (fsck say 2328735), but i need translate =
to LBA sector, and still i dont know how do. ( i found on internet but =
i close the tab jejejjeje)

Best regards
Christian

PD:what is top posting and how i can avoid? hotmail givme 2 options: Re=
ply, and Reply to All


NO responda a esta casilla de email, favor de responder a:
sch@schlabs.com.ar

be free, be linux


----------------------------------------
> Date: Fri, 4 Apr 2014 16:17:03 +0200
> From: swmike@swm.pp.se
> To: sdvileskis@gmail.com
> CC: schnet@hotmail.com; linux-raid@vger.kernel.org
> Subject: Re: Problem Syncing raid1
>
> On Fri, 4 Apr 2014, Scott D'Vileskis wrote:
>
>> I apologize if my relatively simplistic summary of what may actually
>> be happening left out the detail of pending sectors. In my
>> understanding, during a SMART self test, if a problem is encountered
>> and can be dealt with, it can probably handle the transition through
>> pending sectors, without the user ever witnessing the pending sector
>> count increase.
>> How else does one explain increases in reallocated sector counts
>> following a long self test?
>
> I don't know, I have never seen this behavior. It might very well be =
that
> different vendors use different methods for the different scenarios. =
I
> would love to be able to talk to someone who actually works for a HDD
> manufacturer and has real first hand knowledge how things work, inste=
ad of
> what I usually see here (including myself) which is people trying to =
poke
> the black box and trying to figure out what might be going on inside =
from
> the scarce diagnostic tools available.
>
> Personally I've never seen a pending sector go away without writing t=
o it.
> Sometimes this write results in the reallocated count going up, somet=
imes
> it doesn't.
>
> --
> Mikael Abrahamsson email: swmike@swm.pp.se
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
