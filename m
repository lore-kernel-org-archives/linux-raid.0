From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 9 Nov 2009 09:09:11 +0100
Message-ID: <20091109080910.GE18545@boogie.lpds.sztaki.hu>
References: <4AF6D0A9.6000901@gmail.com>
 <4AF6D461.3050109@gmail.com>
 <4AF6D5FD.2010602@gmail.com>
 <4AF70791.9080007@sauce.co.nz>
 <4AF741A9.80701@gmail.com>
 <4AF74D39.3000304@sauce.co.nz>
 <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Andrew Dunn <andrew.g.dunn@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 08, 2009 at 09:45:40PM -0500, Ryan Wagoner wrote:

> This is interesting to hear as I have been using smartmontools on my
> Supermicro LSI 1068E controller with the target firmware for 2 years
> now on CentOS 5. I have 3 RAID 1 arrays across 2 drives, a RAID 5
> drive across 3 drives, and a RAID 0 across 2 drives.

[...]

> uname -r
> 2.6.18-128.4.1.el5

Kernel version matters. With 2.6.22 we only got occassional complaints
that the drives are not capable of SMART checks that were not true but
were otherwise harmless. With 2.6.26 and 2.6.30, the controller offlines
the disks.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
