From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-6 now in 2.6.1-mm
Date: Mon, 19 Jan 2004 13:48:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401191848.i0JImOi01560@dns1.watkins-home.com>
References: <bufult$c06$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bufult$c06$1@terminus.zytor.com>
To: "'H. Peter Anvin'" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can anyone explain how RAID6 works?  I understand RAID5, XOR, but I don't
see how that could be extended to allow any 2 disks to fail.

Thanks.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of H. Peter Anvin
Sent: Monday, January 19, 2004 1:50 AM
To: linux-raid@vger.kernel.org
Subject: RAID-6 now in 2.6.1-mm

Hi all,

For those who haven't seen yet, RAID-6 has been integrated into the
2.6.1-mm kernels.  Please test it out and let me know how it works
out.

The mdadm patch is still at:

    ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/

    -hpa


