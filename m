From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Adding a smaller drive
Date: Sun, 05 Jul 2009 20:05:53 -0400
Message-ID: <yq1ws6m65ge.fsf@sermon.lab.mkp.net>
References: <20090703154609101.MIIG19322@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090703154609101.MIIG19322@cdptpa-omta02.mail.rr.com> (Leslie
	Rhorer's message of "Fri, 3 Jul 2009 10:46:21 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Leslie" == Leslie Rhorer <lrhorer@satx.rr.com> writes:

>> I do think, however, that you are underestimating the power of
>> industry associations and standards bodies.  System manufacturers,
>> enterprise customers and governments absolutely refuse to buy things
>> that are not compliant.  So this is not about whether you can legally
>> cut corners.  It is about being able to sell your product in the
>> first place.

Leslie> 	So a company like Apple could never compete with IBM?

Who says that Apple doesn't care about the LBA count?  Most desktop
system vendors use disk imaging to perform burn-in and software preload.
It matters to them.  Same goes for OS deployment on the business desktop
end of things.

I don't have any idea whether more desktop class drives are sold
individually as opposed to as part of a new computer.  But that doesn't
really matter.  Because fact is that it's the system vendors that set
the bar for standards compliance.

I am not sure what the incentive would be for the drive vendors to
provide different capacities/firmware loads for drives sold directly to
consumers.  Until the IDEMA LBA spec was ratified we were talking about
capacity variations of a few percent within a given class.  I don't
think consumers care about that nearly as much as we computer
professionals do.


Leslie> There are myriad examples of non-compliant software and hardware
Leslie> being developed in a standards-based environment yet selling
Leslie> very well.  I think maybe you are underestimating the vast
Leslie> buying power of individual consumers and non-enterprise
Leslie> businesses.  

I don't disagree that there's a lot of crap hardware out there.
Absolutely.  And a sizable portion of said crap is in the USB-ATA bridge
designed-by-dyslexic-monkeys category.

However, there's only a handful of disk drive manufacturers.  And they
are all pretty good at adhering to existing standards for the reasons I
outlined earlier.  Namely that they have to sell exactly the same drives
to customers with higher standards than aforementioned dyslexic monkeys.

Here's the LBA count for a bunch of currently shipping 3.5" 1TB drives
that I was able to find the data sheets for within a couple of minutes
of googling:

DRIVE				LBA COUNT
---------------------------------------------
Hitachi Deskstar 7K1000:	1,953,525,168
Hitachi Deskstar 7K1000.B:	1,953,525,168
Seagate Barracuda ES.2:		1,953,525,168
Seagate Barracuda 7200.11:	1,953,525,168
Seagate Barracuda 7200.12:	1,953,525,168
Seagate Barracuda LP:		1,953,525,168
Samsung SpinPoint F1 DT:        1,953,525,168
Samsung Ecogreen F2:		1,953,525,168
WDC Caviar Black:		1,953,525,168
WDC Caviar Green:		1,953,525,168
WDC Caviar RE3:			1,953,525,168
WDC Caviar RE2-GP:		1,953,525,168
---------------------------------------------


Leslie> Well, first of all, in this very thread someone gave an example
Leslie> of a modern drive which is apparently non-compliant. 

That turned out to be a drive sitting behind a RAID controller which
reserves a portion of the drive for its own use.

-- 
Martin K. Petersen	Oracle Linux Engineering

