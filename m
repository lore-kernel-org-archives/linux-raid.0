From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 18:23:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706151823360.32724@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467273AB.9010202@argo.co.il>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@argo.co.il>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jun 15 2007 14:10, Avi Kivity wrote:
>
>Some things are not achievable with block-level raid.  For example, with
>redundancy integrated into the filesystem, you can have three copies for
>metadata, two copies for small files, and parity blocks for large files,
>effectively using different raid levels for different types of data on
>the same filesystem.

Sounds like you want RAIF, not RAID.



	Jan
-- 
