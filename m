From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: NCQ general question
Date: Wed, 8 Mar 2006 17:51:08 +0100
Message-ID: <20060308165108.GA19567@apartia.fr>
References: <4405A656.1030602@rtr.ca> <20060301135547.GV4816@suse.de> <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com> <4408C0D9.4010202@garzik.org> <98B59AFC-2781-4A8A-82E4-C923B4A48F9E@egenera.com> <4409E623.5070707@garzik.org> <C7155197-3E90-4EDF-9D1A-5A5210248938@egenera.com> <311601c90603041556oce5a50ev8379ea39fa7b65cc@mail.gmail.com> <5d96567b0603042319v7b08184cq918fe4ac32da61e3@mail.gmail.com> <440A934B.1050505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <440A934B.1050505@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 05, 2006 at 02:29:15AM -0500, Jeff Garzik wrote:
> Raz Ben-Jehuda(caro) wrote:
> >Is NCQ supported when setting the controller to JBOD instead of using HW 
> >raid?
> 
> 1) The two have nothing to do with each other
> 
> 2) It sounds like you haven't yet read
> http://linux-ata.org/faq-sata-raid.html

Hello,

Do you plan on updating your AHCI NCQ patch found in 
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/archive/
It no longer applies cleanly to the latest 2.6.15.x kernel.

Thanks,
