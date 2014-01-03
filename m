From: Joe Landman <joe.landman@gmail.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 23:58:49 -0500
Message-ID: <52C64389.3080106@gmail.com>
References: <52C1C01A.7010407@ubuntu.com>	<52C57C7B.80400@shiftmail.org>	<52C588A7.6010207@hardwarefreak.com>	<52C59468.6080200@ubuntu.com>	<52C5A9AA.9090300@hardwarefreak.com>	<52C5BC28.2020003@gmail.com> <21189.62662.712801.352081@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21189.62662.712801.352081@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxraid2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/02/2014 06:22 PM, Peter Grandi wrote:

>    # grep . /sys/block/sd?/queue/physical_block_size
>    /sys/block/sda/queue/physical_block_size:512
>    /sys/block/sdb/queue/physical_block_size:4096
>    /sys/block/sdc/queue/physical_block_size:4096
>    /sys/block/sdd/queue/physical_block_size:512
>    /sys/block/sde/queue/physical_block_size:4096
>    /sys/block/sdf/queue/physical_block_size:512
>
> They are all 2TB "consumer" drives, mostly recent ones. I am
> slightly surprised that half still have 512 physical sectors.

Gaak ... our HGST are showing this as well.  For some reason I think I 
have an old sdparm when I looked before.  Trust that the kernel will 
rarely lie to you even if the tools that work with it do.


[root@unison ~]# grep . /sys/block/sd*/queue/physical_block_size
/sys/block/sdaa/queue/physical_block_size:4096
/sys/block/sdab/queue/physical_block_size:4096
/sys/block/sdac/queue/physical_block_size:512
/sys/block/sdad/queue/physical_block_size:4096
/sys/block/sdae/queue/physical_block_size:4096
/sys/block/sdaf/queue/physical_block_size:4096
/sys/block/sdag/queue/physical_block_size:4096
/sys/block/sdah/queue/physical_block_size:4096
/sys/block/sdai/queue/physical_block_size:4096
/sys/block/sdaj/queue/physical_block_size:4096
/sys/block/sdak/queue/physical_block_size:512
/sys/block/sdal/queue/physical_block_size:4096
/sys/block/sdam/queue/physical_block_size:4096
/sys/block/sdan/queue/physical_block_size:4096
/sys/block/sdao/queue/physical_block_size:4096
/sys/block/sdap/queue/physical_block_size:4096
/sys/block/sdaq/queue/physical_block_size:4096
/sys/block/sda/queue/physical_block_size:4096
/sys/block/sdar/queue/physical_block_size:4096
/sys/block/sdas/queue/physical_block_size:512
/sys/block/sdat/queue/physical_block_size:512
/sys/block/sdau/queue/physical_block_size:4096
/sys/block/sdav/queue/physical_block_size:4096
/sys/block/sdaw/queue/physical_block_size:4096
/sys/block/sdax/queue/physical_block_size:4096
/sys/block/sday/queue/physical_block_size:512
/sys/block/sdaz/queue/physical_block_size:512
/sys/block/sdba/queue/physical_block_size:4096
/sys/block/sdbb/queue/physical_block_size:4096
/sys/block/sdbc/queue/physical_block_size:4096
/sys/block/sdbd/queue/physical_block_size:4096
/sys/block/sdbe/queue/physical_block_size:4096
/sys/block/sdbf/queue/physical_block_size:4096
/sys/block/sdbg/queue/physical_block_size:512
/sys/block/sdbh/queue/physical_block_size:512
/sys/block/sdbi/queue/physical_block_size:4096
/sys/block/sdbj/queue/physical_block_size:4096
/sys/block/sdbk/queue/physical_block_size:512
/sys/block/sdbl/queue/physical_block_size:512
/sys/block/sdb/queue/physical_block_size:4096
/sys/block/sdc/queue/physical_block_size:4096
/sys/block/sdd/queue/physical_block_size:4096
/sys/block/sde/queue/physical_block_size:512
/sys/block/sdf/queue/physical_block_size:4096
/sys/block/sdg/queue/physical_block_size:4096
/sys/block/sdh/queue/physical_block_size:4096
/sys/block/sdi/queue/physical_block_size:4096
/sys/block/sdj/queue/physical_block_size:4096
/sys/block/sdk/queue/physical_block_size:4096
/sys/block/sdl/queue/physical_block_size:4096
/sys/block/sdm/queue/physical_block_size:512
/sys/block/sdn/queue/physical_block_size:4096
/sys/block/sdo/queue/physical_block_size:512
/sys/block/sdp/queue/physical_block_size:4096
/sys/block/sdq/queue/physical_block_size:4096
/sys/block/sdr/queue/physical_block_size:4096
/sys/block/sds/queue/physical_block_size:4096
/sys/block/sdt/queue/physical_block_size:4096
/sys/block/sdu/queue/physical_block_size:512
/sys/block/sdv/queue/physical_block_size:4096
/sys/block/sdw/queue/physical_block_size:4096
/sys/block/sdx/queue/physical_block_size:4096
/sys/block/sdy/queue/physical_block_size:4096
/sys/block/sdz/queue/physical_block_size:4096



This is one of the day job's large Ceph boxen.  The 4k units are HGST 
4TB enterprise drives, and the 512B units are SSDs.

