From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: Can't start raid 5 when device names have changed
Date: Fri, 10 Jan 2003 10:49:47 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.51.0301101046080.23820@ddx.a2000.nu>
References: <200301100335.h0A3ZHt02424@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200301100335.h0A3ZHt02424@dns1.watkins-home.com>
To: bugzilla@watkins-home.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 9 Jan 2003 bugzilla@watkins-home.com wrote:

> Please help!  I can resolve the problem by addressing the new disks so they
> will be sde and sdf.  But this seems like it could be a major problem for
> others in the future.  You should be able to add disks to a system without
> such problems.

Hi,

solution is to use mdadm :

mdadm -A /dev/md3  --force /dev/sda1 /dev/sdc1 /dev/sde1 /dev/sdf1

(make sure these are the correct disks with mdadm -Q /dev/sda1 (and
sdc1...))
