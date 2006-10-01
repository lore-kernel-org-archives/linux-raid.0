From: andy liebman <andyliebman@aol.com>
Subject: Simulating Drive Failure on Mirrored OS drive
Date: Sun, 01 Oct 2006 19:55:07 -0400
Message-ID: <4520555B.4080000@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Various documents on Mirrored OS Drives suggest you can simulate the 
failure of one of your mirrored pairs by marking one or more partitions 
as "failed" with mdadm.

Indeed when I mark a drive as "failed", if I have the mdadm monitoring 
daemon running, I get an email warning me that my RAIDS are degraded.

Also, I can reboot with only one drive plugged in and the OS comes up 
fine (albeit degraded).

This gives me a REASONABLE degree of confidence that the Mirrored 
Partitions will continue working okay if one drive should fail. However, 
I would like to run a more definitive test.

I tried simply unplugging one drive from its power and from its SATA 
connector. The OS didn't like that at all. My KDE session kept running, 
but I could no longer open any new terminals. I couldn't become root in 
an existing terminal that was already running. And I couldn't SSH into 
the machine.

It was like I had an OS running on only a 1/4th of a cylinder. I 
couldn't even make the OS cleanly shutdown or reboot.

I know that simply unplugging a drive is not the same as a drive failing 
or timing out. But is there a more realistic way to simulate a failure 
so that I can know that the mirror will work when it's needed?

Andy Liebman
