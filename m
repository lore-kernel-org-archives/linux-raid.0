From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: corrupt raid 5
Date: Wed, 04 Jan 2006 16:40:11 +0300
Message-ID: <43BBD03B.2020301@tls.msk.ru>
References: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>	 <17339.20993.529499.281141@smtp.charter.net> <5981e8c80601032135p312a37e0kf8c4e3d6edd05e53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5981e8c80601032135p312a37e0kf8c4e3d6edd05e53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lorac Thelmwood <lorac.web@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lorac Thelmwood wrote:
> Seatools is a DOS based tool.  It doesn't matter what OS you have.  It
> just examines the drives themselves, not the filesystem.  It is used
> to check if your drives are bad.

FYI, seatools package is available for linux too, linux version can
be found at the same place on seagate website as the dos version.

Besides, with current software available for linux, seatools isn't
really needed -- the functionality of seatools is already here when
you look at scsitools, sg3-utils, smartmontools.  With seatools
(which is closed-source btw, and will only work with seagate disks),
everything is bundled in a single application, but the same functionality
plus much more is available elsewhere on linux.

/mjt
