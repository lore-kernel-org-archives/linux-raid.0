From: "Jeff Unruh" <jeff@jdubya.org>
Subject: RE: LVM on top of software raid5
Date: Sat, 4 Dec 2004 15:23:08 -0600
Message-ID: <200412042122.iB4LMr8H024129@ms-smtp-02-eri0.texas.rr.com>
References: <c7c98a00412031639292ce21b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c7c98a00412031639292ce21b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steven Joerger' <steven.joerger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steven,

A little googling will help.  I am running a gentoo box using raidtools with
3x200 Seagate Drives in a Raid5 array with LVM2 (I know - I need to convert
to mdadm but not sure how).

Here are a few links that helped me out - using LVM2.

http://www.gentoo.org/doc/en/lvm2.xml

http://www.tldp.org/HOWTO/LVM-HOWTO/

I am using /dev/md2 (/dev/vg0) as my music and video repository and it is
ever growing so LVM is helpful to manage the size and expand when necessary.


// Jeff

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steven Joerger
Sent: Friday, December 03, 2004 6:39 PM
To: linux-raid@vger.kernel.org
Subject: LVM on top of software raid5

Hello List,

Can anyone point me to a decent guide for setting up LVM on a software
raid 5. I'm particularly interested in being able to grow the size of
the raid at some point.

Thanks in advance.
Steve
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

