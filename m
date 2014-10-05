From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Hot replacing device in RAID 6
Date: Sun, 5 Oct 2014 18:46:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1410051843040.14735@uplift.swm.pp.se>
References: <CAAOsTSmn3MDn-a6usUTpmBObwYngvFNNRUXXF6zhmDKyUTHU_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1222308165-1412527510=:14735"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmn3MDn-a6usUTpmBObwYngvFNNRUXXF6zhmDKyUTHU_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1222308165-1412527510=:14735
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 5 Oct 2014, Patrik Horník wrote:

> I want to ask for best solution for replacing device in RAID 6 array.
>
> - We discussed couple of years ago hot replacing the drive. I see it
> is now supported in mdadm. Is it rock stable and can be used on
> production data? I have kernel and mdadm from debian testing, 3.14-2
> and 3.3-2. Were there some important fixes from these versions? I have
> this server on UPS but not on aggregator so there is real danger of
> power outage and need to shutdown the array during operation.

I have successfully used the replace function without ill effects, and I 
believe this was with a 3.8.x kernel. The function itself has been around 
since 3.3 or so.

I don't want to give you any recommendations, but next time I need to 
replace a failing drive that is still operational enough to stay in the 
raid, personally I will use the replace function. The code is a few years 
old by now and I imagine it has been used quite a lot by now.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1222308165-1412527510=:14735--
