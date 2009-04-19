From: "NeilBrown" <neilb@suse.de>
Subject: Re: Spares Missing event in case of spare group?
Date: Mon, 20 Apr 2009 06:39:04 +1000 (EST)
Message-ID: <0ad180f4fb306d79e27eb9c822acdbaf.squirrel@neil.brown.name>
References: <49EB4B07.9050208@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EB4B07.9050208@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, April 20, 2009 2:02 am, Jan Ceuleers wrote:
> Hi!
>
> I have two RAID1 sets of equal size, with one spare shared between them.
> When I reboot the system I get a Spares Missing notification on one of
> the arrays.
>
> Since this is a false positive, is there a way to avoid it?

Yes.  Remove the "spares=1" from each line.
The sole effect of this text is to tell --monitor to expect a spare, and
to complain if no spare is found.

NeilBrown


>
> Extract from mdadm.conf:
>
> ARRAY /dev/md0 level=raid1 num-devices=2 spares=1
> UUID=19e69537:f7a6aec8:5a5f7576:3fc29e0d spare-group=swapgroup
> ARRAY /dev/md1 level=raid1 num-devices=2 spares=1
> UUID=5e728621:c8b356a8:01f8e270:f0e280cb spare-group=swapgroup
>
> Thanks, Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

