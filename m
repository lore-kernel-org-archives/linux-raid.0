From: Eric Pretorious <eric@pretorious.net>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Wed, 29 Jun 2005 15:57:01 -0700
Message-ID: <200506291557.01559.eric@pretorious.net>
References: <200506291538.03233.eric@pretorious.net>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506291538.03233.eric@pretorious.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mike V <mike@asacomputers.com>
List-Id: linux-raid.ids

On Wednesday 29 June 2005 03:38 pm, Eric Pretorious wrote:
>I'm trying to install CentOS 3.3 (a.k.a. RedHat Enterprise Linux 3) on a 
>Supermicro 5013C-M8 w/ on-board Adaptec AIC-7902 Ultra320 controller 
>(connected to two Seagate ST373207LC 73GB hdd's in RAID1 connfiguration) but 
>am getting random crashes. (The screen is FILLED with I/O errors and raid1 
>messages.)

Oops: It's a Supermicro P4SC8 motherboard.

On reboot, the Adaptec BIOS fails to scan the SCSI bus (and, subsequently, the 
system fails to boot). Could this be a hardware failure?

-- 
Eric P.,
Truckee, CA
