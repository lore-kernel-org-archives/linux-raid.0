From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Sat, 14 Nov 2009 12:07:54 -0500
Message-ID: <4AFEE3EA.9080503@tmr.com>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz> <20091112075203.GA22315@maude.comedia.it> <4AFC3299.3040702@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFC3299.3040702@ribosome.natur.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Martin MOKREJ=C5=A0 wrote:
> Hi everybody,
>
> That is what happened to me. Two disks are not in an ICH9R array but =
are
> in raid0 under mdadm. Four disk are under raid10 under ICH9R while al=
so
> under raid10 under mdadm.
>  =20

Could you clarify that last sentence? It sounds as if you have two=20
independent arrays, using a controller for one and mdraid for the other=
,=20
and they both use the same drives. Please tell me I'm misreading this..=
=2E

--=20
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
