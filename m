From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 16:18:03 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002171617150.28940@uplift.swm.pp.se>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1144405204-1266419883=:28940"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1144405204-1266419883=:28940
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 17 Feb 2010, Kristleifur Daðason wrote:

> Starting on sector 64 feels conceptually "prettier" than Sector 63,
> but I can't picture the case where it behaves any different. Except

If you have WD20EARS drives with 4k sectors on-disk you'll get ~1/3 
performance if you start on sector 63 instead of an even 4k boundary.

Always go for even 4k boundary.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1144405204-1266419883=:28940--
