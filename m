From: dean gaudet <dean@arctic.org>
Subject: Re: Checking individual drive state
Date: Sun, 5 Nov 2006 12:44:56 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611051237080.13706@twinlark.arctic.org>
References: <454E02EE.5030209@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <454E02EE.5030209@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bradshaw <breadlord@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Nov 2006, Bradshaw wrote:

> I've recently built a smallish RAID5 box as a storage area for my home
> network, using mdadm. However, one of the drives will not remain in the array
> for longer that around two days before it is removed. Readding it to the array
> does not throw any errors, leading me to believe that it's probably a problem
> with the controller, which is an add-in SATA card, as well as the other drive
> connected to it failing once.
> 
> I don't know how to scan the one disk for bad sectors, stopping the array and
> doing an fsck or similar throws errors, so I need help in determining whether
> the disc itself is faulty.

try swapping the cable first.  after that swap ports with another disk and 
see if the problem follows the port or the disk.

you can see if smartctl -a (from smartmontools) tells you anything 
interesting.  (it can be quite difficult, to impossible, to understand 
smartctl -a output though.  but if you've got errors in the SMART error 
log that's a good place to start.)


> If the controller is to be replaced, how would I go about migrating the two
> discs to the new controller whilst maintaining the array?

it depends on which method you're using to assemble the array at boot 
time.  in most cases if these aren't your root disks then a swap of two 
disks won't result in any troubles reassembling the array.  other device 
renames may cause problems depending on your distribution though -- but 
generally when two devices swap names within an array you should be fine.

you'll want to do the disk swap with the array offline (either shutdown 
the box or mdadm --stop the array).

-dean
