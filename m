From: "Francois Barre" <francois.barre@gmail.com>
Subject: Bigendian issue with mdadm
Date: Mon, 20 Feb 2006 22:38:22 +0100
Message-ID: <fd8d0180602201338t5f728fem@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

Please, Help !

I've created a raid5 array on a x86 platform, and now wish to use it
on a mac mini (g4 based). But the problem is : the first is
little-endian, the second big-endian...
And it seams like md superblock disk format is hostendian, so how
should I say mdadm to use a endianness ?

Thanks for help,

F.-E.B.
