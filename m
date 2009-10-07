From: adfas asd <chimera_god@yahoo.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Wed, 7 Oct 2009 10:58:27 -0700 (PDT)
Message-ID: <891314.17866.qm@web38807.mail.mud.yahoo.com>
References: <20091006005026746.OZOR12917@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091006005026746.OZOR12917@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Mon, 10/5/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>  Indeed, as I mentioned, adfas might be well
> served with LVM volumes
> on each machine.  It certainly would provide great
> performance, although as
> I also mentioned, I don't think drive performance is really
> his problem, per
> se.

Hang on a sec.  LVM would make it easy to add drives.  And as I understood it, you recommend a RAID in the garage and another in the HTPC, LVMed together?  Well with this I could add another array, but that's not what's needed.  I'd need to add a drive to the garage and another to the HTPC, which means each of those arrays would need to be completely reconstructed.

OTOH if I set up the garage as an LVM and the HTPC as another, then RAID those LVMs together, maybe I could add a drive to each LVM... AS LONG AS I add the same size drive to BOTH the garage and HTPC for expansion?  And no need to completely reconstruct the RAID array?


      
