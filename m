From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Thu, 18 Sep 2014 13:22:29 +0200
Message-ID: <A5356EE1-B54E-42F8-A6E9-090A537761F3@gmail.com>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com> <20140912082403.549fc298@notabene.brown> <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com> <BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com> <20140915101830.3c85d423@notabene.brown> <DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com> <20140918200347.762845bb@notabene.brown> <D28F9C01-C75C-4B69-932F-FA2425DEDDB4@gmail.com> <20140918210942.113acb17@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140918210942.113acb17@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 18.09.2014, at 13:09, NeilBrown <neilb@suse.de> wrote:

> Thanks.  There is nothing there which point to the device being spun =
down.
> I tried spinning down disks on a couple of machines and no udev event=
s were
> created.  So I'm a bit suspicious that there is something I'm missing=
=2E
>=20
> How exactly do you spin down the devices?
> I use "hdparm -Y /dev/sda" or "hdparm -S 1 /dev/sda".

I=92m using spindown (https://code.google.com/p/spindown) which in turn=
 uses sg3-utils (http://sg.danny.cz/sg/sg3_utils.html), issuing "sg_sta=
rt =97stop DEVICE"
I can confirm there=92s no change events with hdparm -Y here either. bu=
t with sg_start =97stop there are.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
