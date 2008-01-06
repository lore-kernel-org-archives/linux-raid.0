From: Jim <jim@fayettedigital.com>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Sun, 06 Jan 2008 06:13:06 -0500
Message-ID: <4780B7C2.3030909@fayettedigital.com>
References: <477FAAAC.2090107@fayettedigital.com> <20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>
Reply-To: jim@fayettedigital.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nagilum wrote:
>
>
> Since /dev/hdb5 has been part of this array before you should use 
> --re-add instead of --add.
> Kind regards,
> Alex.
>
OK

root@chinaberry:~# mdadm  /dev/md0 --re-add /dev/hdb5
mdadm: Cannot open /dev/hdb5: Device or resource busy

Jim
