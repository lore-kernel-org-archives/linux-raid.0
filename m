From: Luca Berra <bluca@comedia.it>
Subject: Re: raid1 resync data direction defined?
Date: Mon, 30 Jul 2007 10:09:08 +0200
Message-ID: <20070730080908.GA7044@percy.comedia.it>
References: <20070727130713.GA12058@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070727130713.GA12058@janus>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 27, 2007 at 03:07:13PM +0200, Frank van Maarseveen wrote:
>I'm experimenting with a "live" migration of /dev/sda1 using mdadm -B
>and network block device as in:
>
>	mdadm -B -ayes -n2 -l1 /dev/md1 /dev/sda1 \
>		--write-mostly -b /tmp/bitm$$ --write-behind /dev/nbd1
not a good idea

>/dev/sda1 is to be migrated. During the migration the local system
>mounts from /dev/md1 instead. Stracing shows that data flows to the
>remote side. But when I do
>	echo repair >/sys/block/md1/md/sync_action
>
>then the data flows in the other direction: the local disk is written
>using data read from the remote side.
I believe stracing nbd will give you a partial view of what happens.
anyway in the first case since the second device is write-mostly, all
data is read from local and changes are written to remote
In the second one the data is read from both sides to be compared, that
is what you are seing on strace, i am unsure as to which copy is
considered correct, since md does not have info about that.

>If that would happen in the first command then it would destroy all
yes
>data instead of migrating it so I wonder if this behavior is defined:
no
>Do mdadm --build and mdadm --create always use the first component device
>on the command-line as the source for raid1 resync?
no

if you are doing a migration, build the initial array with the second
device as "missing"
then hot-add it and it will resync correctly
i.e
mdadm -B -ayes -n2 -l1 /dev/md1 /dev/sda1 \
        --write-mostly -b /tmp/bitm$$ --write-behind missing
mdadm -a /dev/md1 /dev/sda1 

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
