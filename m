From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: Incorrect array member slot assignment during assemble
Date: Sun, 20 Apr 2008 23:12:01 -0300
Message-ID: <18443.63473.834200.366911@fisica.ufpr.br>
References: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080420183552.c0g0cm4mucsc8844@mail.jp-hosting.net>
Sender: linux-raid-owner@vger.kernel.org
To: jay@bernard.vm.bytemark.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jay@bernard.vm.bytemark.co.uk (jay@bernard.vm.bytemark.co.uk) wrote on 20 April 2008 18:35:
 >I had a single disk failure in a 3-disk RAID5 array recently, and have  
 >been trying to reassemble the array with the remaining devices, but am  
 >running into some issues.
 >
 >The failed disk died during synchronization into the array,

Did another one fail during the resync? If not you can try to
reassemble the array with only the 2 good disks using --force.

If a second disk failed you're in trouble. Since the array stopped at
the moment of the second failure, the two disks are still in sync.
Well, almost... You can then make an image of the second failed disk
on a good one and use --force to reassemble again. Then fsck...
