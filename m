From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 15:30:20 -0500
Message-ID: <CAKHEz2Z-v+ax_tig49M6-D-Sjfd1mW7PajZmsGtGwvR+Bp+WEw@mail.gmail.com>
References: <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
	<31549980.18.1360612152269.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31549980.18.1360612152269.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

On Mon, Feb 11, 2013 at 2:49 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.ne=
t> wrote:
>> Why would you plug thousands of dollars of SSD into an onboard
>> controller? It's probably running off a 1x PCIE shared with every
>> other onboard device. An LSI 8x 8 port HBA will run you a few
>> hundred(less than 1 SSD) and let you melt your northbridge. At least
>> on my Supermicro X8DTL boards I had to add active cooling to it or i=
t
>> would overheat and crash at sustained IO. I can hit 2 - 2.5GB a seco=
nd
>> doing large sequential IO with Samsung 840 Pros on a RAID10.
>
> Those onboard controllers are usually connect to 8x PCIe or similar. =
Also, those controllers from LSI won't allow TRIM support, which may co=
me in handy=85
>

Be sure to check your motherboard documentation each time though. It
turned out his was connected to a 4x DMI 2.0 bus which I had mistaken
as a DMI 1.0 even after reading the docs. Thats approximately a 4x
PCI. It was still shared with all the other devices on the motherboard
including another 4x slot and gigabit ethernet adapters. Also it
wasn't a very good SATA controller even. You can get onboards that are
decent. I have several builds that come with onboard LSI SAS
controllers. Just those are hooked directly to the northbridge on a
dedicated 4x PCIE.

The LSI RAID doesn't support TRIM, I don't know any hardware
controller that does at yet. I just use them as plain HBAs with md for
the raid. When I get a kernel with the mdtrim patches TRIM will just
magically(hopefully) start working.


--=20
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
