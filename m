From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Adaptec 2010s boot failure
Date: Thu, 13 Mar 2003 08:22:39 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0303130740200.25127@filesrv1.baby-dragons.com>
References: <200303130936.h2D9aIK20410@mailgate.mailbox.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200303130936.h2D9aIK20410@mailgate.mailbox.co.za>
To: Vlad Milovanovic <vlad@webmail.co.za>
Cc: Nick DeClario <nick@guardiandigital.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Hello Vlad ,  I'm sorry to hear that you had problems .

	The key problem with the driver in most distro's ,  it appears to
	be that the driver has been compliled with the in kernel i2o & if
	the driver is compiled with that it either locks or oop's .  From
	adaptec's linux site they make particular point to NOT compile it
	against in kernel version of i2o .

	The way I was able to install was like this .  The book that came
	with the 2010s has a description of doing something very simular
	to what I am descibing here .  But ...

	Insert a supported scsi card .  Install your distro on -one-
	drive ,  Make sure the kernel loaded has the dpt_i2o is compiled
	in AND that is has NOT been compiled with the Kernel version of
	i2o (ie: do not enable i2o) .
	Once you have that system booting properly .  Back it up .

	Now that is accomplished replace the scsi card with the 2010s and
	enter the SMOR ((*)iow just hit Crtl-A at the right time) .
	Create a raid1 (this is the ONLY functionality that works with
	this process) ,  have the raid1 mirror from the selected disk to
	another that can boot .  Verify that the setup is what is wanted .
	I beleive at this point that the controller mentions that the
	selections made will not take effect until after a reboot .
	Do so .  Then ee-enter SMOR(*) & have it rebuild the array .
	After that is accomplished . You should be able to boot into the
	system .  Hth ,  JimL

On Thu, 13 Mar 2003, Vlad Milovanovic wrote:

> Hi Nick,
>
> I had that same card, and it gave me countless problems and headaches.
> One thing that I can remember for sure, is that I *never* managed to
> get anything to boot of any disk that was connected to the card. I
> don't know if I was doing somethingh wrong, but given the amount of
> times I have done this sort of thing it is unlikely.
>
> Also I remember having to pass the IRQ and the I/O of the card to the
> module with insmod, but it sounds like you have done that since you
> are installing fine.
>
> Therefore it is my guess that this is not a bootable card. May I
> suggest a small IDE disk for the /boot ?
>
>
>
>
> On Wed, 12 Mar 2003 19:21:06 -0500 Nick DeClario
> (nick@guardiandigital.com) wrote:
>
> >Hi.  I have an Adaptec 2010s running on an Intel SE7501WV2
> motherboard.
> >   I can get both EnGarde Linux and RedHat Linux 8.0 to install
> >perfectly but both systems fail on boot.  The RedHat system refuses
> to
> >load the kernel and reports "Isufficient memory" while the EnGarde
> >system starts to load the kernel into memory, stops and prints 80.
> >
> >I have searched for quite some time for information about this card
> and
> >have been coming up empty handed.  I can't even find references to it
> in
> >the kernel.  Adaptec does list the 2010s as compatible with the Intel
> >SE7501WV2 motherboard and RedHat 8.0 as well.
> >
> >Does anyone have any suggestions or can point me to more information?
> >
> >Thanks,
> >     -Nick
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> //--------------------------------------
> Vlad Milovanovic
> vlad@webmail.co.za
> _______________________________________________________________
>  http://www.webmail.co.za the South-African free email service
>
>   NetWiseGurus.Com Portal - Your Own Internet Business Today!
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+
