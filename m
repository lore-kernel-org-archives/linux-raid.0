From: Luca Berra <bluca@comedia.it>
Subject: Re: raid 0+1 and 1+0 with mdadm
Date: Fri, 1 Oct 2004 22:55:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041001205528.GC31475@percy.comedia.it>
References: <1096566962.3539.15.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1096566962.3539.15.camel@rich>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 30, 2004 at 10:56:03AM -0700, rich turner wrote:
>when I run "mdadm -As" i get the following output:
>mdadm: /dev/md3 has been started with 3 drives.
>mdadm: /dev/md4 has been started with 3 drives.
>mdadm: /dev/md6 has been started with 2 drives and 1 spare.
>mdadm: /dev/md7 has been started with 2 drives and 1 spare.
>mdadm: no devices found for /dev/md5
>mdadm: no devices found for /dev/md8
>
>if i then immediately run "mdadm -As" again it starts /dev/md5 and
>/dev/md8.
>
>why do i have to run it twice and why does it not start all devices the
>first time?
>
i believe the device line is evaluated first, then all array lines
processed.
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
