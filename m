From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Sun, 25 Jun 2017 01:23:41 +0200
Message-ID: <6bf63a01-ffe8-6653-437f-85bc2ed502d8@thelounge.net>
References: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Hubert Reevez <hubereevez@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 25.06.2017 um 00:21 schrieb Hubert Reevez:
> I'm trying to add a larger spare in replacement to a smaller one. I'm
> really stuck here.... ;(
> 
> Here is what I did : --fail /dev/sdc then --remove /dev/sdc
> 
> Added the new one (which is also sdc now) can't assemble the new one !
> 
> If I try to assemble here is what it comes :
> ---------------------------------------------------------
> root@Zetta:~# mdadm --assemble /dev/md0 --verbose /dev/sdc
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc is busy - skipping
> -------------------------------------------------------

in all cases where i replaced mdadm drives i used "mdadm /dev/md0 --add 
/dev/sdc" and never --assemble
