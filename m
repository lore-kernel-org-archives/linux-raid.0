From: thomas62186218@aol.com
Subject: Re: md devices disappearing on system reboot
Date: Mon, 07 Jul 2008 20:44:26 -0400
Message-ID: <8CAAEAAE80876A0-11A4-4676@webmail-nc18.sysops.aol.com>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com>	<20080702162108.GF4981@skl-net.de>	<8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com>	<20080707093004.GQ23944@skl-net.de>	<8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com>	<20080707132319.GR23944@skl-net.de>	<8CAAE7C73AB975E-26A8-1E6E@webmail-stg-d10.sysops.aol.com>	<4872A2A6.2060908@dgreaves.com> <18546.43017.93866.476968@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18546.43017.93866.476968@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, david@dgreaves.com
Cc: maan@systemlinux.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I tried using the "1" at the end but still no luck.

mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has no superblock - assembly aborted

Thank you for your input so far. Any ideas on this one?

-Thomas

-----Original Message-----
From: Neil Brown <neilb@suse.de>
To: David Greaves <david@dgreaves.com>
Cc: thomas62186218@aol.com; maan@systemlinux.org; 
linux-raid@vger.kernel.org
Sent: Mon, 7 Jul 2008 4:34 pm
Subject: Re: md devices disappearing on system reboot










On Tuesday July 8, david@dgreaves.com wrote:
> thomas62186218@aol.com wrote:
> > Hi Andre,
> >
> > Thank you very much for the quick response.
> >
> > My /dev/md0 device is using /dev/sdd1, /dev/sdg1, /dev/sdj1, and 
/dev/sdm1.
> >
> > I did:
> > devices=/dev/sd[dgjm]
> ^^^^ add a 1 to the end...
> devices=/dev/sd[dgjm]1
>
> > mdadm -A --run /dev/md0 $devices

Also please add -vv to get more verbose output.
So:

   mdadm -A -s -vv
and when that fails
   mdadm -A --run -vv /dev/sd[dgjm]1

Thanks,
NeilBrown





