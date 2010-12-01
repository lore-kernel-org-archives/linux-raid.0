From: hansbkk@gmail.com
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best of
 both worlds?
Date: Thu, 2 Dec 2010 02:47:45 +0700
Message-ID: <AANLkTi=SXuv=ms8HsfSKSnXAveAq1=OefRkZV9ACTLdC@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>
	<4CF3F7A0.2080108@rjl.com>
	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>
	<4CF4A472.20107@rjl.com>
	<AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
	<4CF4F85C.1020806@turmel.org>
	<AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>
	<4CF52CA5.1090405@turmel.org>
	<AANLkTin4f=W69mr923KhSYT_qvFnLiz0fpScWo0w1rfu@mail.gmail.com>
	<4CF64495.80700@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF64495.80700@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Wed, Dec 1, 2010 at 7:50 PM, Phil Turmel <philip@turmel.org> wrote:
>> Does dd already do some sort of "verify after copy"? I will likely
>> investigate the available COTS partition cloning tools as well.
>
> Not natively, but it fairly easy to pipe a dd reader through md5sum t=
o a dd writer, then follow up with a dd read + md5sum of the copied par=
tition (taking care to read precisely the same number of sectors).
>
> The various flavors of ddrescue might have something like this.. =A0d=
idn't check.

Sorry it's a bit OT, but for the sake of future googlers thought I'd
point to this tool I found:

http://dc3dd.sourceforge.net/
http://www.forensicswiki.org/wiki/Dc3dd
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
