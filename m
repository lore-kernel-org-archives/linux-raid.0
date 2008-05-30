From: Tony Germano <tony_germano@hotmail.com>
Subject: RE: Proposal: non-striping RAID4
Date: Fri, 30 May 2008 13:23:57 -0400
Message-ID: <BAY130-W484FAD9B1B0D912A9D9F85E1BE0@phx.gbl>
References: <BAY130-W418FFF9E3F58536967DDEAE1C60@phx.gbl>
 <BC2A76AABABF8741A8ADEE62DB1350F80384C383@exchange2.valvesoftware.com>
 <48382473.8090808@tmr.com>
 <BC2A76AABABF8741A8ADEE62DB1350F80384C398@exchange2.valvesoftware.com>
 <483DE756.6020004@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483DE756.6020004@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Unfortunately I'm not very familiar with writing driver code, and I'm
painfully out of practice with writing code in general. For someone
interested in looking, the source for the modified md driver is
available from lime-technology that they use to implement these
features. I don't know if I'm able to attach the files to this message,
so I'll just tell you how to get them.

Download from
http://lime-technology.com/dnlds/ the unRAID Server install. I got
version 4.2.4. I used 7zip (I'm in Windows at work) to open the archive
and then open the bzroot image. The source files are in
bzroot\[Content]\usr\src\linux-2.6.20\drivers\md\ . Hopefully that will
be useful to someone.



> Date: Wed, 28 May 2008 19:14:30 -0400
> From: davidsen@tmr.com
> To: cgreen@valvesoftware.com
> CC: tony_germano@hotmail.com; linux-raid@vger.kernel.org
> Subject: Re: Proposal: non-striping RAID4
>
> Agree, you can't get that with current kernel, although I think the
> parts are there to actually make it work. All it would take is some
> clever calling of raid-4 operations to get it going. It's not trivial=
,
> but if you knew the code it might fall out by laying the raid-4 out a=
nd
> just changing the mapping such that all of the sequential sectors fal=
l
> on the same device. Interesting summer project for someone.

_________________________________________________________________
Give to a good cause with every e-mail. Join the i=92m Initiative from =
Microsoft.
http://im.live.com/Messenger/IM/Join/Default.aspx?souce=3DEML_WL_ GoodC=
ause--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
