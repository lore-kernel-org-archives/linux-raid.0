From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: /boot on RAID5 with GRUB
Date: Fri, 11 Nov 2005 16:35:51 -0700
Message-ID: <1131752151.15335.14.camel@maddy.taylor.com>
References: <437516E8.5080000@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437516E8.5080000@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Spencer Tuttle <rodeojones@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-11-11 at 15:10 -0700, Spencer Tuttle wrote:
> Is it possible to have /boot on /dev/md_d0p1 in a RAID5 configuration 
> and boot with GRUB?

Last I checked, GRUB did not have the RAID drivers to read RAID5 before
the kernel was up.  It can, however boot from RAID1.

Forrest

