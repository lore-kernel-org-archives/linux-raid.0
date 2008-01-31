From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: Documentation? failure to update-initramfs causes Infinite md
 loop on boot
Date: Wed, 30 Jan 2008 18:44:31 -0600
Message-ID: <47A119EF.70509@pobox.com>
References: <47A0FB0E.5020202@pobox.com> <20080130224200.GF1446@baikonur.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130224200.GF1446@baikonur.stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maximilian attems wrote:

> pretty simple, you change mdadm.conf put it also on initramfs:
> update-initramfs -u -k all

Sure, that's what I did after boot on rescue, chroot, etc. However, I 
wonder if the *documentation* -- Wiki, or even the man page discussion 
on boot -- should mention that changes in the mdadm.conf have to be 
propogated to /boot?

In fact, that's an interesting question: which changes have to propagate 
to /boot? I'd think any change that affects md devices with /etc/fstab 
entries set to "auto" would have to be followed by update-initramfs. 
That's quite some bit of hidden knowledge if true.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
   "All friends have real and imaginary components."
                      -- Moshe Yudkowsky
