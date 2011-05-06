From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 15:26:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105061525520.20305@uplift.swm.pp.se>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu>
 <20110506123336.GC22617@www2.open-std.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1932789980-1304688412=:20305"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506123336.GC22617@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1932789980-1304688412=:20305
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 6 May 2011, Keld Jørn Simonsen wrote:

> I am proposing that we call our raid10 layout types for RAID1 - in 
> accordance with SNIA standards, and in accordance with the common 
> understanding as demonstrated by you and others, even here on the 
> linux-raid kernel mailing list.

Just so we're clear, if I create a raid1 with 4 drives I want 4 identical 
copies of the same information, not RAID1+0.

How should this be handled with your suggestion?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1932789980-1304688412=:20305--
