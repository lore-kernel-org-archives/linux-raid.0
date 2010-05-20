From: Neil Brown <neilb@suse.de>
Subject: Re: Shrink mdadm RAID5 from 6 disks to 5?
Date: Fri, 21 May 2010 07:34:33 +1000
Message-ID: <20100521073433.75a59a99@notabene.brown>
References: <AANLkTimSxarJKmCxfOkJZJJULplm0z1pbVKyQpCG6nEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimSxarJKmCxfOkJZJJULplm0z1pbVKyQpCG6nEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Keith ." <lukano@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 May 2010 07:45:23 -0600
"Keith ." <lukano@gmail.com> wrote:

> Does mdadm 3.1.x not support shrinking the number of disks in a RAID5 array?
> 
> I have successfully converted my 6x1.5tb RAID6 array to a 6x1.5tb
> RAID5 array.  The issue that I now face is that one of those 6 drives
> is failed / removed, and as a result - the new RAID5 array is down
> it's parity drive.
> 
> I knew I was short a disk when I started the process, but I was under
> the assumption that mdadm now supported shrinking of RAID5/6 arrays.
> Am I mistaken, or can anyone throw some suggestions at me so I can
> give it a try?

It should work.

 mdadm -G /dev/mdX --raid-devices 5 --array-size=XXXXX
 --backup=/root/backup-file

If you don't give the 'array-size' value mdadm will tell you what it has to
be.  You need to be sure that all your data is already within that space.

NeilBrown
