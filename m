From: greg@wind.enjellic.com (Dr. Greg Wettstein)
Subject: Re: Anyone clueful on forcing 3ware drive discovery?
Date: Mon, 12 Sep 2005 09:17:46 -0500
Message-ID: <200509121417.j8CEHkwu017338@wind.enjellic.com>
References: <olchansk@sam.triumf.ca>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Konstantin Olchanski <olchansk@sam.triumf.ca>
       "Re: Anyone clueful on forcing 3ware drive discovery?" (Sep  8, 12:34pm)
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@sam.triumf.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sep 8, 12:34pm, Konstantin Olchanski wrote:
} Subject: Re: Anyone clueful on forcing 3ware drive discovery?

Hi Konstantin, thanks for the note.

> On Thu, Sep 08, 2005 at 02:14:32PM -0500, Dr. Greg Wettstein wrote:
> > We are using a number of 3Ware 75xx and 8xxx controller cards...
> > Last week we had a 7508 kick a drive on an AEN, presumably tripped by
> > a SMART event on the drive.  After the error the controller disavowed
> > all knowledge of the drive and we had to power cycle the machine to
> > get the controller card to recognize the drive.

> I once saw a similar fault with a SATA disk on a 3ware-SATA controller-
> it could not be accessed until power cycled. I assume the disk firmware
> crashed (or whatever) and stopped talking on the SATA interface. 
> 
> Maybe some hot-plug hardware allows cycling power on individual disks
> without physically walking/cycling/driving to the computer and doing
> it the hard way by pulling the disk out (pulling a spinning disk out, bad,
> bad, bad!).

Thanks for the data-point.

I'm actually less concerned about pulling a SATA drive, especially one
which has been configured into a hot-plug chassis.  One of the design
tenants of SATA was to support this.  I will hopefully be doing some
testingn this week with our SATA based machines.  I haven't had
feedback from 3Ware but we will see what the hardware does in this
situation.

I wouldn't even attempt to pull a PATA drive.  They were just never
designed for that sort of thing.

> Konstantin Olchanski

Thanks again for taking the time to reply.

Best wishes for a productive week.

}-- End of excerpt from Konstantin Olchanski

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"The vast majority of human beings dislike and even dread all notions
with which they are not familiar.  Hence it comes about that at their
first appearance innovators have always been derided as fools and
madmen."
                                -- Aldous Huxley

