From: Luca Berra <bluca@comedia.it>
Subject: Re: error opening /dev/md2: No such file or directory
Date: Thu, 2 Dec 2004 21:43:52 +0100
Message-ID: <20041202204351.GF28157@percy.comedia.it>
References: <conlcb$14p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <conlcb$14p$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 02, 2004 at 06:03:45PM +0000, Robin Bowes wrote:
># mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdc1 missing
>mdadm: error opening /dev/md2: No such file or directory
>
>I've used "missing" since the other spare partition is on /dev/sdf which 
>is being RMA'd at the moment - guess what make it is :)
>
>The new FC3 system is running udev with which I'm not familiar.
>
>How can I create the /dev/md2 device?

ah, udev, what a great pile of shit it is.

you could use the --auto= option of mdadm to have it create the device
for you, the only issue with that is that mdadm will use the first free
minor numbr it finds instead of using the minor implied by the device
name. (i was planning on changing that behaviour sooner or later).


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
