From: Larry Fenske <LFenske@SGI.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size, why?
Date: Wed, 26 Mar 2014 12:01:51 -0600
Message-ID: <5333160F.8060007@SGI.com>
References: <tencent_66C345191B9B49B92956F243@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <tencent_66C345191B9B49B92956F243@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tide <lovetide@qq.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Your RAID 6 array has an internal bitmap, while your RAID 5 array does not.

- Larry Fenske
SGI signature

Senior Software Engineer
SGI

