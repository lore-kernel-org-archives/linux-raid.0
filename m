From: Luca Berra <bluca@comedia.it>
Subject: Re: adding multipath device without reboot?
Date: Tue, 30 May 2006 19:33:14 +0200
Message-ID: <20060530173314.GE4022@percy.comedia.it>
References: <447C4FC5.3030502@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <447C4FC5.3030502@cc.kuleuven.be>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 30, 2006 at 03:59:33PM +0200, Herta Van den Eynde wrote:
>I'm trying to add a new SAN LUN to a system, create a multipath mdadm 
>device on it, partition it, and create a new filesystem on it, all 
>without taking the system down.
>
>All goes well, up to partitioning the md device:
>
>   # fdisk /dev/md12
wait!
you cannot partition an md device.
if you need you have to use an mdp device,
but do you?
if you just want to create a single filesystem, as you do below, use the
md device directly.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
