From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Moving controllers
Date: Mon, 22 Mar 2004 14:25:26 -0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <24101.194.60.85.4.1079965526.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a question about moving drives between controllers with software RAID.

I'm planning on building a linux box with a large software RAID5 array (4
x 250/300GB disks) on which to store rips of my CD collection.

The server I have earmarked for this has built-in to it a "HighPoint
HPT370 PCI Dual Channel Ultra DMA/ATA 100 RAID Controller". I plan to
connect my four disks to the two ports of this controller, i.e. I will
have a master and slave drive on each channel.

First question: what is the kernel support like for this controller?

Secondly, I am aware that this is not the ideal configuration, but my
performance requirements are not massive as I won't be doing much more
than streaming MP3s to clients on my home network. However, if I were to
discover that performance was unacceptable I want to know if it would be
possible to install an additional controller in a PCI slot, and move the two
slave disks onto the new controller without re-building the array.

So, expressing my question explicitly:

Can I initially create a RAID5 array on this disk configuration:

HPT370--+--Channel A--+--master (Disk1)
        |             |
        |             +--slave (Disk2)
        |
        +--Channel B--+--master (Disk3)
                      |
                      +--slave (Disk4)

...then move the disks around like this:

HPT370--+--Channel A--+--master (Disk1)
        |
        +--Channel B--+--master (Disk3)

FooBar--+--Channel A--+--master (Disk2)
        |
        +--Channel B--+--master (Disk4)

...or this:

FooBar--+--Channel A--+--master (Disk1)
        |
        +--Channel B--+--master (Disk3)
        |
        +--Channel C--+--master (Disk2)
        |
        +--Channel D--+--master (Disk4)

...or even this:

FooBar 1--+--Channel A--+--master (Disk1)
          |
          +--Channel B--+--master (Disk3)

FooBar2--+--Channel A--+--master (Disk2)
         |
         +--Channel B--+--master (Disk4)


...without trashing the array?

Third question: If I were to decide on a replacement 4-port controller,
what models are well-supported?

Finally, I'd be interested to learn of any issues I might run into when
dealing with disks and filesystems of this size. For example, are there
any inherent limitations or absolute maximums I need to be aware of? What
about low-level issues like chunk size and block size, etc.? Any
recommendations as to the optimum settings, bearing in mind I will be
dealing with relatively large files?

Thanks for all comments.

R.
-- 
http://robinbowes.com
