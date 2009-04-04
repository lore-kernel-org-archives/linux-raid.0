From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: raid6 slow
Date: Sat, 4 Apr 2009 01:37:23 -0500
Message-ID: <20090404063725.YBZW22375.cdptpa-omta01.mail.rr.com@Leslie>
References: <200904031805.17976.Dexter.Filmore@gmx.de>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200904031805.17976.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>Linux+NFS have a tendency to screw up. I suggest swappign NFSd for sshfs
>and 
>see if all is good then.
I can shut down NF entirely and it makes no difference.  Indeed, I can even
shut down both NFS and SAMBA and only read / write between local file
systems and the problem still occurs.

