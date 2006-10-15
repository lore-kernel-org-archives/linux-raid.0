From: Ray Greene <raygr@es.co.nz>
Subject: Re: Cannot create RAID5 - device or resource busy
Date: Sun, 15 Oct 2006 13:39:14 +1300
Message-ID: <in03j2hucuncm5f01t638rrfqfbnmgp9ao@4ax.com>
References: <b8j0j2p670ad9v56fiubtk3c8ej841mp2b@4ax.com> <Pine.LNX.4.64.0610141445490.13112@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 14 Oct 2006 14:46:04 -0400 (EDT), Justin Piszcz
<jpiszcz@lucidpixels.com> wrote:

>See if its mounted/etc first, if not: mdadm -S /dev/md0 (stop it)
>
>Then try again.

That fixed it. Thanks Justin.

-- 
Ray Greene

