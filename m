From: Neil Brown <neilb@suse.de>
Subject: Re: weird SparesMissing event
Date: Wed, 11 Aug 2010 17:57:11 +1000
Message-ID: <20100811175711.40cb75c9@notabene>
References: <4C624B80.9030304@qumido.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C624B80.9030304@qumido.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Gunkel <tobias.gunkel@qumido.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 Aug 2010 09:04:32 +0200
Tobias Gunkel <tobias.gunkel@qumido.de> wrote:

> Hello everyone,
> 
> I've got a strange SparesMissing event on one of my raid1 arrays.
> mdadm --detail /dev/md2 says all ok, but I get this message by mdadm
> monitor every day:
> 
> A SparesMissing event had been detected on md device /dev/md2.

This means that /etc/mdadm/mdadm.conf says /dev/md2 has more spare devices
than it currently has.  What is in /etc/mdadm/mdadm.conf



> This makes me wonder, too:
> 
> root@MCI03:~# mdadm --examine --scan
> ARRAY /dev/md0 UUID=304f5f2a:fbc8082b:54307b3d:1949437b
>    spares=1
> ARRAY /dev/md1 UUID=b263f9c1:5c680152:54307b3d:1949437b
>    spares=1
> ARRAY /dev/md2 UUID=7aa24776:9d6e8d24:54307b3d:1949437b
>    spares=2
> 
> Why spares=2 for md2? It was created during Debian system install with
> spares=1.

What do you get if you run

 mdadm --examine --scan --verbose

it should add a 'devices=' line which will show you which devices it is
counting.

NeilBrown
