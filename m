From: hansbkk@gmail.com
Subject: Re: removing AHCI SATA devices
Date: Wed, 23 Feb 2011 17:54:36 +0700
Message-ID: <AANLkTimMYVNFqmFGB4MKCqarQg87h3CB9J2APGZJ3h70@mail.gmail.com>
References: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com>
	<4D642C54.9040604@garzik.org>
	<4D64C503.1080304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D64C503.1080304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just check it yourself before pulling the drive.

If you have lots of volumes mounted:

mount | grep sdN



On Wed, Feb 23, 2011 at 3:27 PM, Simon McNair <simonmcnair@gmail.com> w=
rote:
> thanks Jeff. =A0 It just seems like a hit and miss solution (no way o=
f knowing
> all data has been written to and that the device has been unmounted f=
rom all
> filesystems). =A0I kinda expected some kind of 'it is safe to remove =
/dev/sdb'
> in dmesg.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
