From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID10 vs. LVM on RAID1
Date: Mon, 22 Aug 2005 19:19:27 -0400
Message-ID: <200508222319.j7MNJWE20973@www.watkins-home.com>
References: <20050822213100.GA6165@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050822213100.GA6165@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net, 'Linux RAID list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

RAID10 will work with an odd number of disks.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Gregory Seidman
> Sent: Monday, August 22, 2005 5:31 PM
> To: Linux RAID list
> Subject: RAID10 vs. LVM on RAID1
> 
> Is there any advantage to RAID10 over creating an LVM volume group across
> the same number of RAID1 pairs? LVM does striping, after all. Am I
> overlooking something?
> 
> --Greg
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

