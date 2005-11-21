From: Gil <gil@fooplanet.com>
Subject: Re: comparing FreeBSD to linux
Date: Mon, 21 Nov 2005 11:00:59 -0800
Message-ID: <4382196B.2030209@fooplanet.com>
References: <5d96567b0511210647n144bcda6p53d2eb9ba20a8ebc@mail.gmail.com> <200511211733.jALHXGE01893@www.watkins-home.com> <5d96567b0511211010j36f37f06we47f3b6edc35d314@mail.gmail.com> <5d96567b0511211015w88b5005n696899abb43c356e@mail.gmail.com> <20051121182024.GA4590@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051121182024.GA4590@havoc.gtf.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Guy <bugzilla@watkins-home.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Garzik wrote:
> On Mon, Nov 21, 2005 at 10:15:11AM -0800, Raz Ben-Jehuda(caro)
> wrote:
> 
>> Well , i have tested the disk with a new tester i have written.
>> it seems that the ata driver causes the high cpu and not raid.
> 
> Which drivers are you using?  lspci and kernel .config?

And have you turned on DMA?

hdparm /dev/hda

--Gil
