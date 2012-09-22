From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 12:30:28 -0600
Message-ID: <FF5F85AF-C7AA-4EA0-9871-26A87A28690F@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <1718683.C0AtuyUDq1@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1718683.C0AtuyUDq1@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 22, 2012, at 2:37 AM, G=FCnther J. Niederwimmer wrote:

> But I mean I have read in the changelog from parted 3.1, it is a Raid=
(1) GPT=20
> Error Bug corrected ?

I don't think this is related to parted, honestly. Did you partition sd=
a and sdb before you created the RAID container? I think the problem is=
 that the IMSM metadata has stepped on the GPT secondary partition at t=
he end of the sda and sdb, that's what you original post indicates.=20

I could be wrong but it seems like the problem is that sda and sdb shou=
ldn't even have a GPT in the first place, they should just be treated a=
s raw physical devices for Intel Raid to take over, and you'd only crea=
te a GPT for the virtual device (the array) within. If correct, the way=
 to get rid of the kernel GPT error messages would be to remove the unn=
ecessary GPT structures from sda and sdb, leaving only the IMSM metadat=
a intact.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
