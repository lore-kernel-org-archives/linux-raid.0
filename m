From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 12:55:13 -0600
Message-ID: <ACFFFD9C-EA43-4DDB-80B3-173F03937674@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com> <505EF9F3.7000908@anonymous.org.uk> <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com> <D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com> <506029DB.3080407@anonymous.org.uk> <8AB64122-6198-4A2E-BA49-76BD6AFE7907@colorremedies.com> <CABYL=ToFtzXv95At54=jSCaD0QVSB+bdxbssda1AMw5gNBqvhg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=ToFtzXv95At54=jSCaD0QVSB+bdxbssda1AMw5gNBqvhg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 24, 2012, at 12:17 PM, Roberto Spadim wrote:

> i used some disks one or two years ago of 1.5TB, when i boot the disk=
 for the first time the bios recognized it as a 1TB disk, i change some=
 bios parameters (removed from automatic) and i could put it to work wi=
th 1.5TB could you check if it=B4s a bios problem? in my case the disk =
appears as 1TB when it booted wrong, and after changing bios options it=
 goes nice with 1.5TB

I don't think that's related. The disks size aren't being misreported. =
And it's also a UEFI [1] computer, not BIOS [2], therefore again there =
shouldn't be any concern about firmware induced disk size misinterpreta=
tion. But then, I'd also not expect a UEFI computer to offer a GPT inco=
mpatible RAID implementation either =96 I'm still hoping I've got this =
wrong somehow.


Chris Murphy


[1] UEFI has no bugs. Not a single one.

[2] I can't be the only one who finds it irritating that even the manuf=
acturers persist in conflating UEFI and BIOS: All of Intel's firmware d=
ownloads for G=FCnther's/OP's motherboard are referred to as BIOS. I re=
ally wish they wouldn't do that.--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
