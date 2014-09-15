From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Mon, 15 Sep 2014 12:52:07 +0200
Message-ID: <DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com> <20140912082403.549fc298@notabene.brown> <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com> <BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com> <20140915101830.3c85d423@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140915101830.3c85d423@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 15.09.2014, at 02:18, NeilBrown <neilb@suse.de> wrote:

> It would help to get "udevadm monitor" info to correlate with this.
> Presumably some uevent is generated when the spindown happens.  udev =
might
> respond to this by reading from the device, which defeats the purpose=
=2E..
>=20
>=20
>>=20
>> here=92s the output of blktrace -d /dev/sda during that time.
>> https://dl.dropboxusercontent.com/u/3464720/blktrace.tar.bz2
>=20
> That suggest that something is reading the metadata from the device a=
lmost
> constantly.  Mostly a 'kworker' thread.  I don't know what would caus=
e that.
>=20
> Let's look at the 'udevadm monitor' trace first and see what that sho=
ws.

here=92s the output of udevadm monitor during the spindown cycle while =
mdadm-3.3 is installed.

monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[299719.336261] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (bloc=
k)
UDEV  [299720.646760] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (bloc=
k)
KERNEL[299780.202901] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (bloc=
k)
UDEV  [299781.567308] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (bloc=
k)
KERNEL[299841.090818] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (bloc=
k)
UDEV  [299842.407035] change   /devices/pci0000:00/0000:00:06.0/0000:09=
:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (bloc=
k)

please note that the issue immediately disappears when downgrading to m=
dadm-3.2 without touching anything else.
I see the udev rules have been updated in mdadm-3.3..

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
