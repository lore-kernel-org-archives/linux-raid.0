From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 7 Jun 2014 18:52:16 -0600
Message-ID: <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140607075140.277c0880@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

I wrote:
> How can there still be pending bad sectors, and yet no error and LBA =
reported?

So I started another -t long test. And it comes up with an LBA not prev=
iously reported.

# 1  Extended offline    Completed: read failure       60%      1214   =
      430234064

# dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8
dd: writing to =91/dev/sda=92: Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 3.63342 s, 0.0 kB/s

On this sector the technique fails.

# dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8 oflag=3Ddi=
rect
8+0 records in
8+0 records out
4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s

This technique works.

However, this seems like a contradiction. A complete -t long results in=
:

# 1  Extended offline    Completed without error       00%      1219   =
      -

and yet

197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Alway=
s       -       16

How are there 16 pending sectors, with no errors found during the exten=
ded offline test? In order to fix this without SMART reporting the affe=
cted LBAs, I'd have to write to every sector on the drive. This seems l=
ike bad design or implementation.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
