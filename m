From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: best way to try recovering inactive raid6
Date: Sun, 19 Dec 2010 16:01:15 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1012191559010.27193@uplift.swm.pp.se>
References: <AANLkTin71JrpmKJC6df+ZX7jsm7P8RwCzUSfV8CMWk2v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1790758269-1292770755=:27193"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin71JrpmKJC6df+ZX7jsm7P8RwCzUSfV8CMWk2v@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1790758269-1292770755=:27193
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 19 Dec 2010, Bjørn Eikeland wrote:

> Hope you guys can help me out with some input here!

What mdadm and kernel version are you using?

If you're not using the latest mdadm version (3.1.4 afaik) then try 
--assemble --force with that one first. It does a better job than most of 
the versions that come with most distributions today.

Recreating the array is highly dangerous and it's definitely a last 
resort.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1790758269-1292770755=:27193--
