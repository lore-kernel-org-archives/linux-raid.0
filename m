From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Tue, 05 Feb 2008 05:43:31 -0600
Message-ID: <47A84BE3.407@pobox.com>
References: <200802051142.19625.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802051142.19625.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 1. Where this info on array resides?! I have deleted /etc/mdadm/mdadm.conf 
> and /dev/md devices and yet it comes seemingly out of nowhere.

/boot has a copy of mdadm.conf so that / and other drives can be started 
and then mounted. update-initramfs will update /boot's copy of mdadm.conf.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
