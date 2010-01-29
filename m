From: Carlos Williams <carloswill@gmail.com>
Subject: Re: Re-arranged Drives in MDADM?
Date: Fri, 29 Jan 2010 09:02:52 -0500
Message-ID: <d80f793f1001290602y5684c034vb18c2cd1ee354019@mail.gmail.com>
References: <d80f793f1001281058g60228b6bo7fc001fcfedd4487@mail.gmail.com>
	 <20100128213924.GA1664@cthulhu.home.robinhill.me.uk>
	 <20100129204051.320d1fa2@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129204051.320d1fa2@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 4:40 AM, Neil Brown <neilb@suse.de> wrote:
> Or possibly shut down, physically swap the devices, and the start up again.

I noticed when I created the RAID5 array on my Linux server using the
mdadm command:

mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sda2 /dev/sdb2
/dev/sdc2 --spare-devices=1 /dev/sdd2

The above command create a /etc/mdadm.conf file which showed 2 spare
devices because one of the spares was rebuilding as the 3rd member of
the RAID5 array. Once the rebuild / sync was complete on /dev/sdc2, it
would not longer show as a spare. My question is does the data in
/etc/mdadm.conf need to be accurate after the RAID has been created
and established? Once the rebuild was complete and all 3 drives were
synced, the mdadm.conf file was never updated so I deleted the
contents of the file and ran:

mdadm -D --scan >> /etc/mdadm.conf

I didn't see a real reason to do so but I did it just to be consistent
with my system and avoid issues later.

Does anyone have any thoughts on this?
