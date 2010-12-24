From: Spelic <spelic@shiftmail.org>
Subject: Re: Aliens ate my superblock!
Date: Fri, 24 Dec 2010 19:43:30 +0100
Message-ID: <4D14E9D2.6000702@shiftmail.org>
References: <AANLkTimzJEdHDgnKbA5rk1Jwf7471Tib-JW3akEuWbwE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimzJEdHDgnKbA5rk1Jwf7471Tib-JW3akEuWbwE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jean de Largentaye <jean@largentaye.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/24/2010 06:44 PM, Jean de Largentaye wrote:
> Hi folks,
>
> I have a case where I lost the last ~2000 sectors of my hard drives*.
> As that's where the 0.90 superblock is stored, those disks are no
> longer automatically recognized by md. Apart from that part, my disks
> and other hardware is fine.
>
> This is a RAID6 with 6 disks, 3 of which were chomped
>    

Hi Jean
Is the chomped part writable? Otherwise you will first have to copy 
those drives elsewhere.

I think the only way would be to recreate the RAID over the drives with 
--assume-clean so that no resync is made.
(resync would destroy your data)
Be sure to make it same size (don't use smaller partitions) and same 
superblock type.
When recreating the array you have to correctly guess the order of 
devices to make it identical to the first time you created it. Then it 
will become readable.
For the 3 still readable devices you can read their position number via 
mdadm --examine /dev/device  (it's called Array Slot)
If you have 3 devices with unknown position number (array slot) in the 
array you can try all combinations, which are 6.
At each iteration you can try to mount readonly and see if you see 
something.
When you have something readable you can try xfs_repair to fix it 
better. But better to ask in the xfs mailing list first.
If xfs is not repairable an extreme measure is to extract data with 
photorec.
See also older posts in this ML mentioning the --assume-clean trick for 
array recovery, many are from Neil Brown himself.

Merry Christmas to everybody
