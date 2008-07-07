From: David Greaves <david@dgreaves.com>
Subject: Re: md devices disappearing on system reboot
Date: Tue, 08 Jul 2008 00:11:34 +0100
Message-ID: <4872A2A6.2060908@dgreaves.com>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de> <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com> <20080707093004.GQ23944@skl-net.de> <8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com> <20080707132319.GR23944@skl-net.de> <8CAAE7C73AB975E-26A8-1E6E@webmail-stg-d10.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAAE7C73AB975E-26A8-1E6E@webmail-stg-d10.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: maan@systemlinux.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Hi Andre,
> 
> Thank you very much for the quick response.
> 
> My /dev/md0 device is using /dev/sdd1, /dev/sdg1, /dev/sdj1, and /dev/sdm1.
> 
> I did:
> devices=/dev/sd[dgjm]
^^^^ add a 1 to the end...
devices=/dev/sd[dgjm]1

> mdadm -A --run /dev/md0 $devices
> 
> I received:
> mdadm: cannot open device /dev/sdd: Device or resource busy
> mdadm: /dev/sdd has no superblock - assembly aborted
> 
> Any ideas?
> 
> -Thomas

