From: Luca Berra <bluca@comedia.it>
Subject: Re: slackware -current softraid5 boot problem
Date: Tue, 9 May 2006 07:50:49 +0200
Message-ID: <20060509055048.GA22085@percy.comedia.it>
References: <200605090006.32615.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200605090006.32615.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 09, 2006 at 12:06:32AM +0200, Dexter Filmore wrote:
>Finally got me a bunch of disks as a raid 5, I don't even want to boot from 
>it, plain data array. four sata-II samsungs on a sil3114 controller, all fine 
>so far.
>
>Booting the machine I get "no superblock on /dev/sdd, stopping 
>assembly" (or assembly aborted or so)
>After boot has completed, running mdadm --assemble --scan --verbose manually 
>works just fine and doesn't tell a thing about missing superblocks. 
>
you don't give a lot of information about your setup,
in any case it could be something like udev and the /dev/sdd device node
not being available at boot?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
