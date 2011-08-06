From: Thomas Steinborn <thestonewell@googlemail.com>
Subject: mdadm(IMSM): Unsupported attributes : 40000000
Date: Sat, 6 Aug 2011 20:55:47 +0200
Message-ID: <CACHinyGxah6Utp+ed0WKH58BO8-sOn+QX9DPCy9QGNjuDde=eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after updating to mdadm 3.2.2 (by way of upgrading from Fedora 14 to
15) from 3.1.5 I am no longer able to boot my IMSM raid, which I was
able to for the last 5 years or so.

The errors I am getting are:

  mdadm(IMSM): Unsupported attributes : 40000000
  mdadm: IMSM metadata loading not allowed due to attributes incompatib=
ility.

I tracked that down to the patch at

http://www.spinics.net/lists/raid/msg34783.html

According to that patch 40000000 means=A0#define MPB_ATTRIB_NEVER_USE
__cpu_to_le32(0x40000000). Any advice why an unused but aparently set
attribute should stop the raid to boot?

=46or now I am up and running with 3.1.5 but would like to keep up with
the latest mdadm if possible.

Thanks
Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
