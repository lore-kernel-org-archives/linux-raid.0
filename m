From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Strange behaviour on "toy array"
Date: Mon, 16 May 2005 22:28:39 -0400
Message-ID: <200505170228.j4H2Sim20649@www.watkins-home.com>
References: <42891679.2090902@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42891679.2090902@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Patrik Jonsson' <patrik@ucolick.org>, 'Ruth Ivimey-Cook' <Ruth.Ivimey-Cook@ivimey.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My guess is it will not change state until it needs to access a disk.
So, try some writes!

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Patrik Jonsson
> Sent: Monday, May 16, 2005 5:54 PM
> To: Ruth Ivimey-Cook; linux-raid@vger.kernel.org
> Subject: Re: Strange behaviour on "toy array"
> 
> Ruth Ivimey-Cook wrote:
> 
> >
> >Yes, I believe this interpretation is correct. Moreover, I've seen this
> happen
> >"for real": when two drives died on my raid5 array while I was playing, I
> >started to see some I/O errors, but only for things that hadn't just been
> >accessed: recently accessed things were returned fine. As time went by,
> even
> >those disappeared.
> >
> >I must admit, it's rather disconcerting, but it is a logical result of
> having a
> >block cache.
> >
> >
> This makes sense, however, I would have expected /proc/mdstat or
> something telling me the array is DEAD. It seems "clean, degraded" is
> not a proper description of a raid5 without any working drives... Or
> would this not happen until I tried to write to it (which I haven't
> gotten to yet)?
> 
> I must admit I don't remember seeing in the FAQ or anywhere what is
> supposed to happen when you lose more than one drive. I sort of expected
> to have the entire array go offline, but it seems it just limps along
> like a normal faulty drive would do?
> 
> /Patrik
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

