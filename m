From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Detecting array parameters
Date: Wed, 9 Jun 2010 23:13:40 +0200
Message-ID: <20100609211340.GA12172@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

if I understood it correctly, in order to detect
the several array parameters (number of disks, for
example), it is possible to use "mdadm -D /dev/mdX"
or to check the files in the corresponding /sys/block/...
/mdX/... files.

Now, assuming something needs to be done in scripts,
what would be the best way? Using "mdadm -D ... | grep"
(or "mdadm ... | gawk ...."), or to read the proper
files in /sys/block/md...?

Assuming the wanted information is available on both
sides, which does not seem always the case.

Thanks,

bye,

-- 

piergiorgio
