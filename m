From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Unmount a raid device during recovery in progress
Date: Sat, 31 Aug 2013 14:41:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1308311440560.15239@uplift.swm.pp.se>
References: <CAJR_FHz-rF4F_rL57xpYGKw7kuF-bu-dg3o8++M12z7E7wbtzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-488027750-1377952913=:15239"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJR_FHz-rF4F_rL57xpYGKw7kuF-bu-dg3o8++M12z7E7wbtzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Zolt=E1n_T=F6r=F6k?= <torokze@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-488027750-1377952913=:15239
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 31 Aug 2013, Zoltán Török wrote:

> Is it possible to unmount a raid device (/dev/md0) while a recovery is in
> progress?

Yes.

> If yes is it speeds up the recovery process?

Recovery is slowed down by other accesses to the volume. Just having a 
filesystem mounted doesn't cause accesses. Accessing the files on this 
filesystem does.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-488027750-1377952913=:15239--
