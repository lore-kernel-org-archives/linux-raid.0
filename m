From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Relative performance of RAID-5 algorithms
Date: 10 Dec 2003 20:21:16 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <br8rbs$5ac$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

There are four different "checksumming algorithms" -- really, disk
layouts, in Linux.  Is there anything "known" about the relative
performance of these?  The default for mdadm and mkraid is currently
left-symmetric; is that a sensible default?

I'm asking because I'm trying to get my RAID-6 project going, and
these layouts get a lot more complex with two redundancy drives.
Thus, I'm considering just supporting one disk layout at this point,
and I'd like to pick one :)

	-hpa
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
