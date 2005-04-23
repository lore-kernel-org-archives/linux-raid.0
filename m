From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid 10 or 1+0 ?
Date: Sat, 23 Apr 2005 12:21:17 -0400
Message-ID: <200504231621.j3NGLMm17613@www.watkins-home.com>
References: <876ef97a05042304262d0b5c3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876ef97a05042304262d0b5c3a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tobias DiPasquale' <codeslinger@gmail.com>, 'yves DEGLAIN' <admin@avallon.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md supports a built-in RAID10.  RAID10 is not RAID1+0, but it is similar.
RAID10 can be used with an odd number of disks and is a single array.
RAID1+0 is a single RAID0 made of 2 or more RAID1 arrays.

I have never used them, so I can't recommend one over the other.

Some people have problems with RAID1+0, seems the Kernel tries to assemble
the RAID0 array before the RAID1 arrays.  Maybe not on every system.

RAID10 is somewhat new, so may not have had much testing.  I don't recall
anyone posting comments on RAID10.

Maybe we need some success stories for RAID10 and RAID1+0 mounted on "/".

Guy

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Tobias DiPasquale
> Sent: Saturday, April 23, 2005 7:26 AM
> To: yves DEGLAIN
> Cc: linux-raid@vger.kernel.org
> Subject: Re: raid 10 or 1+0 ?
> 
> On 4/22/05, yves DEGLAIN <admin@avallon.be> wrote:
> > is raid 10 work like a raid 1+0  and witch one is the more stable/sure
> > to boot on it as root fs ?
> 
> I believe that RAID 10 == RAID 1+0. They are just two notations for
> the same thing. Thus, either would be equally suitable.
> 
> --
> [ Tobias DiPasquale ]
> 0x636f6465736c696e67657240676d61696c2e636f6d
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

