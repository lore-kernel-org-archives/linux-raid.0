From: "NeilBrown" <neilb@suse.de>
Subject: Re: Wierd critical node problem
Date: Tue, 10 Jun 2008 18:15:22 +1000 (EST)
Message-ID: <58687.192.168.1.70.1213085722.squirrel@neil.brown.name>
References: <200806100924.48763.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200806100924.48763.wayne@flashmedia.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: wayne@flashmedia.co.za
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, June 10, 2008 5:24 pm, Wayne Gemmell wrote:
> Hi all
>
> I run a 4 disk array with 6 RAID 1 partitions. This is a very simple
> configurations which has served me well through multiple drive failures. I
> now have a wierd problem. One of the disks has become a critical node. My
> server does not boot without this disk no matter which disk is my primary
> boot disk (bios). I've changed the order of the disks and it makes no
> difference.
>
> When this disk is not in booting from some of the other disks gives me a
> warning that there is an invalid superblock magic on sda. They all end up
> with an error on stdin and modprobe failing.
>
>
> Any ideas how to resolve this? I'm leaning towards nukeing sd[acd] and
> re-adding them.

I suggest you provide lots more details.
Probably
  mdadm -Dsv
and
  mdadm -Esv
would be a good start.

NeilBrown

