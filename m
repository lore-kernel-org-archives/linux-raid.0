From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: OT: sas controllers/expanders and "desktop" drives?
Date: Sat, 20 Mar 2010 17:42:41 -0700
Message-ID: <40b437201003201742l36b2bc92x82f380862fd81351@mail.gmail.com>
References: <20100317143602.GA18298@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317143602.GA18298@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A couple of years ago, I was managing 2 systems. Both were built with
Supermicro motherboards and chassis and high-end 3ware controllers
(9550sx if I recall correctly). One system was built with
enterprise-class SATA  drives, while the other was built with
desktop-class SATA drives. They were both configured for RAID5.

The system with desktop-class drives occasionally kicked a drive out
of the array. The controller would report that the drive had failed
and then that it was back again a few seconds later, but this was
enough for the controller to kick it out of the array and require a
rebuild.

Caution: one anecdote is not hard data!

Simon

On Wed, Mar 17, 2010 at 7:36 AM, Matt Garman <matthew.garman@gmail.com>=
 wrote:
>
> Hello,
>
> For building a Linux md system with many disks, I've been looking at
> the LSI SAS 3081E-R controller card[1] with the SuperMicro
> 846TQ-R900B chassis[2]. =A0The SAS3018E card looks like it has a
> mature open-source Linux driver. =A0The chassis has a SAS expander;
> I'm not sure which one (but I have a question in to SuperMicro).
>
> Anyway, my question is this: has anyone used this setup, or one
> like it (sas controller + sas expander) with "desktop" class drives?
> The web research I've done suggests that most SAS controllers and
> expanders are targeted at the enterprise market, and therefore,
> aren't guaranteed to work with the (significantly cheaper) desktop
> drives.
>
> For example, from the FAQ for that SuperMicro chassis[3]:
>
> =A0 =A0Question: We want to use the new Seagate 1.5TB ST31500341AS
> =A0 =A0drives in combination with a storage solution based on your
> =A0 =A0846TQ chassis, is this compatible?
>
> =A0 =A0Answer: This ST31500341AS hard drive is designed to be a Deskt=
op
> =A0 =A0type hard drive, not an Enterprise hard drive which is needed =
in
> =A0 =A0this setup. =A0We don't recommend this combination, so please =
use
> =A0 =A0the Seagate 1TB ST31000340NS drive instead. This drive is an
> =A0 =A0Enterprise drive and validated for our 846TQ chassis.
>
> In short, we want to build a server with 24 drives. =A0The desktop
> drives are significantly cheaper than the enterprise drives. =A0But
> getting 24 ports is cheapest with these SAS controllers + expanders.
>
> Thanks,
> Matt
>
>
> [1] http://www.lsi.com/storage_home/products_home/host_bus_adapters/s=
as_hbas/lsisas3081er/index.html
>
> [2] http://www.supermicro.com/products/chassis/4U/846/SC846TQ-R900.cf=
m
>
> [3] http://www.supermicro.com/support/faqs/faq.cfm?faq=3D8230
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
