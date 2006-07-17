From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Mon, 17 Jul 2006 13:13:44 +0200
Message-ID: <62b0912f0607170413x465b363eh92c811da67cc363@mail.gmail.com>
References: <44BAB76D.9070809@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BAB76D.9070809@start.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sevrin Robstad wrote:
> I got a friend of mine to make a list of all the 6^6 combinations of dev
> 1 2 3 4 5 missing,
>
> shouldn't this work ???

Only if you get the layout and chunk size right.

And make sure that you know whether you were using partitions (eg.
sda1) or whole drives (eg. sda - bad idea).
