From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: rescue an alien md raid5
Date: Tue, 24 Feb 2009 13:11:33 -0800
Message-ID: <200902241311.33442.harry.mangalam@uci.edu>
References: <200902231013.46082.harry.mangalam@uci.edu> <49A345BC.1010206@gluesys.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49A345BC.1010206@gluesys.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: hgichon <kpkim@gluesys.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi kpkim,

You mean that the system needs an lvm/lvm2 layer to properly interpret 
the underlying filesystem?  

Possible, but the USR OSS list:
<http://www.usr.com/support/gpl/8700-OpenSourcesList-0.63_USR.xls>
doesn't list lvm as part of their implementation.  Would mdadm have 
been able to detect this?

Harry


On Monday 23 February 2009, hgichon wrote:
> I read USRobotics 8700 feature.
>
> # Supports linear storage use (all drives as one logical drive) or
> use multiple drives as primary and back-up storage
> # Dynamic logical drive sizing - Add an additional drive, when
> needed, and it will be integrated into the logical drive with no
> effect on data
>
> maybe... there is no lvm layer?
> try vgscan / vgchange -ay
>
> best regards.



-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]
