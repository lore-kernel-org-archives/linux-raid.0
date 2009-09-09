From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Wed, 9 Sep 2009 13:04:37 +0200
Message-ID: <slrnhaf2ub.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
 <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20090908184837.GA28217@teal.hq.k1024.org> <4AA70604.7020709@harddata.com>
 <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Jackson <sjackson@bluearc.com> wrote:
> In my case I am using Seagate and Hitachi drives.
> Please can anyone tell me how I would go about setting timeout values on these types of drive. Are there utility programs to do this or a Linux 

Well, my Seagates have a RTL (Recovery time limit (ms)) field in the rw
(Read write error recovery) mode page.

You could try something like `sdparm -W RTL=7000 /dev/sdX' to set it to
7 seconds. I don't know if it works, I didn't test it, use it at your
own risk! Do a backup before, it could blow up your disk or even the
universe :) Tell us if it worked :)


regards
   Mario
-- 
() Ascii Ribbon Campaign
/\ Support plain text e-mail

