From: Maarten <maarten@ultratux.net>
Subject: Re: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 21:55:46 +0100
Message-ID: <200501162155.46495.maarten@ultratux.net>
References: <200501161937.j0GJbn925823@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501161937.j0GJbn925823@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 16 January 2005 20:39, Guy wrote:
> If your rebuild seems too slow, make sure you increase the speed limit!
> Details in "man md".
>
> echo 100000 > /proc/sys/dev/raid/speed_limit_max

Hi Guy,
You always say that, but that never helps me (since my distro already has 
100000 as default).  Are there even distros that have this set too low ? 

Maarten


