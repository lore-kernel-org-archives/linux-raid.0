From: "jeff millar" <wa1hco@adelphia.net>
Subject: Re: Which drives below to which controller?...clarified
Date: Sat, 18 Oct 2003 12:03:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008001c39591$7e8afba0$6401a8c0@wa1hco>
References: <6.0.0.22.2.20031013111015.032c1a58@englishmail.fsu.edu> <007201c39584$747767f0$6401a8c0@wa1hco>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The question wasn't very clear.  Most specifically, which drives connect to
hpt366, which to pdc202xx?

> This isn't strictly a raid question, but it comes up because the machine
has
> several controllers and drives due to raid...
>
> The machine has three controllers and 6 drives has shown below.  But which
> drive letter belongs to which controller?  That information doesn't reside
> anywhere in /proc/ide/* that I can see.  Does it exist some where else?
>
> [jeff@maggie ide]$ ls -l /proc/ide
> total 0
> -r--r--r--    1 root     root            0 Oct 18 10:26 drivers
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hda -> ide0/hda
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hdc -> ide1/hdc
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hde -> ide2/hde
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hdg -> ide3/hdg
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hdi -> ide4/hdi
> lrwxrwxrwx    1 root     root            8 Oct 18 10:26 hdk -> ide5/hdk
> -r--r--r--    1 root     root            0 Oct 18 10:26 hpt366
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide0
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide1
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide2
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide3
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide4
> dr-xr-xr-x    3 root     root            0 Oct 18 10:26 ide5
> -r--r--r--    1 root     root            0 Oct 18 10:26 pdc202xx
> -r--r--r--    1 root     root            0 Oct 18 10:26 via
>
> thanks...jeff
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

