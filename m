From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible availability improvement
Date: Tue, 22 Feb 2011 15:53:30 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1102221552030.11974@uplift.swm.pp.se>
References: <1298385935.2740.5.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1690364820-1298386410=:11974"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1298385935.2740.5.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Micha=B3_Sawicz?= <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1690364820-1298386410=:11974
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 22 Feb 2011, Michał Sawicz wrote:

> When things in md-world break, there's usually some big and long strain
> on the array members. My colleague's idea is to virtually split the
> members into smaller chunks and keep some metadata (events, checksum?)
> for each of them to reduce the extent of recovery needed when faced
> with, say, a power failure.
>
> Does that make sense?

Yes.

Look in the documentation for "write intent bitmap".

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1690364820-1298386410=:11974--
