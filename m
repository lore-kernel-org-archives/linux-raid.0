From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid1 w/ 3 active mirrors?
Date: Sun, 29 May 2005 23:54:32 +0400
Message-ID: <429A1DF8.6050409@tls.msk.ru>
References: <429A13BC.2090809@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429A13BC.2090809@bitzi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Mohr (@ Bitzi) wrote:
> I may have missed this is various docs, but is there any way to make
> a raid1 array which has 3 (or more) active mirrors, rather than 2 mirrors
> and spares?

On our machines with software raid, I usually use all available disks to
create (small) root filesystem on raid1 - which is 2, 3, 4, 5, or even 8
on one machine.  There's no special restriction on number of mirrors in
a raid1 set.  You create raid1 array on top of N disks exactly the same
as you create it on 2 disks.

/mjt
