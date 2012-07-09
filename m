From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: mdadm crash with lots of devs
Date: Tue, 10 Jul 2012 01:06:55 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207100105460.7381@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1207091635040.1330@frira.zrqbmnf.qr> <20120710075044.6acebe1e@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120710075044.6acebe1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Monday 2012-07-09 23:50, NeilBrown wrote:
>> Using mdadm-3.2.2 from openSUSE_12.1:
>> 
>> # modprobe brd rd_size=1 rd_nr=4096
>> # mdadm -C /dev/md9 -l 10 -n 384 /dev/ram{0..383}
>> mdadm: Defaulting to version 1.2 metadata
>> Segmentation fault (core dumped)
>
>It isn't specific to large numbers of devices.

Indeed not, it seems to be related to the rather small size
of the device :)
Using an rd_size=64 (with that old mdadm version) will emit
a warning rather than crash, and rd_size=1024 seems to be
the first working size.
