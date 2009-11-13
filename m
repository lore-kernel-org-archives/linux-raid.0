From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 09:09:42 -0600
Message-ID: <200911130909.42364.lrhorer@satx.rr.com>
References: <200911122253.01626.lrhorer@satx.rr.com> <200911130022.57620.lrhorer@satx.rr.com> <19197.1188.481294.873723@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19197.1188.481294.873723@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I updated homehost, but I keep getting the following:



RAID-Server:/etc/cron.d# mdadm -G /dev/md0 -b internal
mdadm: failed to set internal bitmap.
RAID-Server:/etc/cron.d# /usr/share/mdadm/checkarray /dev/md0
/usr/share/mdadm/checkarray: line 167: echo: write error: Device or resource 
busy

