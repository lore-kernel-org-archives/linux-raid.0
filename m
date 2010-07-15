From: Neil Brown <neilb@suse.de>
Subject: Re: Need help with recovery
Date: Thu, 15 Jul 2010 07:37:29 +0200
Message-ID: <20100715073729.06c4f11a@notabene>
References: <4C3DCB95.9010104@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C3DCB95.9010104@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 14 Jul 2010 16:37:09 +0200
Jan Ceuleers <jan.ceuleers@computer.org> wrote:

> Hi guys.
> 
> I've been having trouble with a four-disk raid5 array, which I now believe were caused by a flaky eSATA cable. The cable has been replaced, and the controller now seems to reliably see all four disks.
> 
> In fact I have five disks, and so a partition on the fifth disk acts as a spare. Over the past several days I've been connecting and disconnecting drives in ways that I didn't realise were unreliable (due to the faulty cable).
> 
> This has resulted in the md metadata being out of sync on the different partitions. Please could someone provide advice as to how to recover this array (which contains an ext3 filesystem)?
> 
> 
> Many thanks!
> 
> Jan


mdadm -A /dev/md2 --force /dev/sd[ade]2

sdc2 this it is a spare, so you don't want it just now.
sdb2 and sde2 both think that are 'device 0', but sde2 is clearly newer.

So run the above mdadm comment (assuming none of the devices have been
renamed again since you created the --examine output), then 
  fsck -n /dev/md2

and make sure it is happy.

If it is you can added sdb2 and sde2 as spares.

NeilBrown
