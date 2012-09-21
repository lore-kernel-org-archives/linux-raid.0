From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Fri, 21 Sep 2012 16:43:52 -0600
Message-ID: <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 21, 2012, at 1:35 PM, Chris Murphy wrote:

> If you're making the RAID with that, it defaults to metadata version =
1.2. But to be sure
> mdadm -E /dev/mdX

Scratch that. I was confused. Try these instead:

mdadm -=96detail-platform
mdadm =96D /dev/md/imsm
mdadm =96E /dev/sdX

Anyway, I'm suspicious that you've got either your SATA controller also=
 with RAID enabled, or you're also using dmraid and it's conflicting wi=
th the md driver. Or you've misconfigured mdadm for imsm. The result is=
 the secondary GPT is getting squished. I think you should read this do=
cument, as it proposes creating a container first, then RAID within tha=
t. If you're creating the RAID entirely from within Windows this may no=
t be what it does.

http://download.intel.com/design/intarch/PAPERS/326024.pdf


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
