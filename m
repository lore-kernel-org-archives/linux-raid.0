From: Neil Brown <neilb@suse.de>
Subject: Re: cpu consumption
Date: Tue, 24 Jan 2006 14:05:27 +1100
Message-ID: <17365.39287.284592.656226@cse.unsw.edu.au>
References: <43D55876.5020800@ula.ve>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gilberto Diaz on Monday January 23
Sender: linux-raid-owner@vger.kernel.org
To: Gilberto Diaz <gilberto@ula.ve>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 23, gilberto@ula.ve wrote:
> 
> Here is my /etc/mdadm/mdadm.conf file
> 
> DEVICE /dev/sd[abcdefghijkl] /dev/md1 /dev/md2 /dev/md3 /dev/md4
> /dev/md5 /dev/md6
> ARRAY /dev/md1 devices=/dev/sda,/dev/sdb
> ARRAY /dev/md2 devices=/dev/sdc,/dev/sdd
> ARRAY /dev/md3 devices=/dev/sde,/dev/sdf
> ARRAY /dev/md4 devices=/dev/sdg,/dev/sdh
> ARRAY /dev/md5 devices=/dev/sdi,/dev/sdj
> ARRAY /dev/md6 devices=/dev/sdk,/dev/sdl

This is a poor choice for an mdadm.conf file.
The device names of 'SCSI' devices are prone to change with changing
system configuration.  If something disappears or is added, all the
names could change, and this will cease to work.
I would strongly recommend putting UUIDs in there.

  echo 'DEVICE /dev/sd[a-l]' > /etc/mdadm/mdadm.conf
  mdadm -Ds | grep -v devices >> /etc/mdadm/mdadm.conf

NeilBrown
