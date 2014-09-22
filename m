From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid5 missing disks during chunk size grow
Date: Mon, 22 Sep 2014 13:44:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se>
References: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1157418266-1411386151=:14735"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Senebald <martin@senebald.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1157418266-1411386151=:14735
Content-Type: TEXT/PLAIN; CHARSET=UTF-8; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 22 Sep 2014, Martin Senebald wrote:

> My idea was, first bringing back the disks in the array then continue the grow (using the backup file)
> add / re-add disk was not working, so i assumed recreate the array with —assume-clean would bring me closer.

Was this an idea you had that you didn't do, or did you actually execute 
on it?

> What would be the best way to tackle this problem?

Send mdadm --examine from all 6 component drives to the list and let's 
take it from there. Under no circumstances do --create on the components.

What kernel version and mdadm version do you have?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1157418266-1411386151=:14735--
