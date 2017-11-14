From: Tobx <net@tobx.de>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 23:28:05 +0100
Message-ID: <86F8F078-A7B4-4AF6-AE7B-6929161850FA@tobx.de>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
 <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
 <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
 <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Song Liu <liu.song.a23@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rudy Zijlstra wrote:
> What is in your mdadm.conf? Usually found in either /etc/ or in /etc/mdadm/

Created with /usr/share/mdadm/mkconf:

HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/test  metadata=1.2 UUID=d59de5cc:02f560ed:ebcb9400:491955d7 name=debian:test
   spares=1

Regards,
Tobi