From: Luca Berra <bluca@comedia.it>
Subject: Re: Should I Start Over?
Date: Wed, 30 Jun 2004 18:55:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040630165540.GA1099@percy.comedia.it>
References: <1147.66.230.1.97.1088603162.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1147.66.230.1.97.1088603162.squirrel@exitwound.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 30, 2004 at 08:46:02AM -0500, Stephen Hargrove wrote:
># cat /proc/mdstat:
>
>Personalities : [raid5]
>read_ahead not set
>unused devices: <none>
>
># cat /etc/mdadm/mdadm.conf
>DEVICE /dev/hd*
>ARRAY /dev/md0 level=raid5 num-devices=3
>UUID=fef44719:ddd66a49:0a337b48:b53e14c0
>   devices=/dev/hdg1,/dev/hdd1,/dev/hdc1
>
># mdadmin --assemble --scan
>mdadm: no devices found for /dev/md0
>
can you try ?
cat /proc/partitions

and

mdadm --examine /dev/hdX1
replacing X with each of your drives

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
