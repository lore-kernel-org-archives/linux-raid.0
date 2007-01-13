From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Sat, 13 Jan 2007 23:38:00 +0000
Message-ID: <87k5zqpkfb.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de> <873b6ere4s.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873b6ere4s.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "13 Jan 2007 18:25:19 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: earny@net4u.de
Cc: Neil Brown <neilb@suse.de>, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 Jan 2007, nix@esperi.org.uk uttered the following:

> On 12 Jan 2007, Ernst Herzberg told this:
>> Then every about 60 sec 4 times
>>
>> event=SpareActive
>> mddev=/dev/md3
>
> I see exactly this on both my RAID-5 arrays, neither of which have any
> spare device --- nor have any active devices transitioned to spare
> (which is what that event is actually supposed to mean).

One oddity has already come to light. My /proc/mdstat says

md2 : active raid5 sdb7[0] hda5[3] sda7[1]
      19631104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md1 : active raid5 sda6[0] hdc5[3] sdb6[1]
      76807296 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

hda5 and hdc5 look odd. Indeed, --examine says

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       22        1      active sync   /dev/sdb6
       3      22        5        2      active sync   /dev/hdc5

    Number   Major   Minor   RaidDevice State
       0       8       23        0      active sync   /dev/sdb7
       1       8        7        1      active sync   /dev/sda7
       3       3        5        2      active sync   /dev/hda5

0, 1, and *3*. Where has number 2 gone? (And how does `Number' differ
from `RaidDevice'? Why have both?)

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
