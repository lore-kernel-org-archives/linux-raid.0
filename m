From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm: question about tests/07autoassemble
Date: Tue, 21 Nov 2017 13:24:22 -0500
Message-ID: <9af3b82d-33c0-2a2d-5f7c-c25c4a189d19@gmail.com>
References: <b10c5be1-0b85-320f-9ded-dd8ad533d31c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b10c5be1-0b85-320f-9ded-dd8ad533d31c@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/08/2017 04:43 AM, Zhilong Liu wrote:
> Hi, Neil and Jes;
>   I have a question that which name is mdadm expected, md0 or md127 here?
> 
> the case is:
> 
> ./mdadm --quiet -CR /dev/md1 -l1 -n2 /dev/loop0 /dev/loop1
> --homehost=testing --auto=yes
> ./mdadm --quiet -CR /dev/md2 -l1 -n2 /dev/loop2 /dev/loop3
> --homehost=testing --auto=yes
> ./mdadm --quiet -CR /dev/md0 -l0 -n2 /dev/md1 /dev/md2
> --homehost=testing --auto=yes
> 
> ./mdadm -Ss
> ./mdadm --quiet -As -c /dev/null --homehost=testing -vvv
> 
> */linux-apta:~/mdadm-test #/* cat /proc/mdstat
> Personalities : [raid1] [raid0]
> md127 : active raid0 md1[0] md2[1]
>       33792 blocks super 1.2 512k chunks
> 
> md2 : active raid1 loop2[0] loop3[1]
>       18944 blocks super 1.2 [2/2] [UU]
> 
> md1 : active raid1 loop0[0] loop1[1]
>       18944 blocks super 1.2 [2/2] [UU]
> 
> unused devices: <none>
> 
> And I have another question, I still don't find "when and where" got the
> name of md127,
> It didn't invoke the find_free_devnm, and I debug with udevadm, still
> confused. would
> you give me some points on it? I would continue to find which code does
> this.

Did you pause between mdadm -Ss and mdadm -As ?

It may be md0 was still in use. You aren't really guaranteed the name,
unless you specify it in /etc/mdadm.conf or on the command line?

Cheers,
Jes
