From: Will Sheffler <willsheffler@gmail.com>
Subject: safest way to swap in a new physical disk
Date: Tue, 14 Nov 2006 00:06:27 -0800
Message-ID: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

What is the safest way to switch out a disk in a software raid array  
created with mdadm? I'm not talking about replacing a failed disk, I  
want to take a healthy disk in the array and swap it for another  
physical disk. Specifically, I have an array made up of 10 250gb  
software-raid partitions on 8 300gb disks and 2 250gb disks, plus a  
hot spare. I want to switch the 250s to new 300gb disks so everything  
matches. Is there a way to do this without risking a rebuild? I can't  
back everything up, so I want to be as risk-free as possible.

I guess what I want is to do something like this:

(1) Unmount the array
(2) Un-create the array
(3) Somehow exactly duplicate partition X to a partition Y on a new disk
(4) Re-create array with X gone and Y in it's place
(5) Check if the array is OK without changing/activating it
(6) If there is a problem, switch from Y back to X and have it as  
though nothing changed

The part I'm worried about is (3), as I've tried duplicating  
partition images before and it never works right. Is there a way to  
do this with mdadm?

For what it's worth, mdadm / linux software raid handles this setup  
beautifully... easy to set up, easy to maintain, easy to fix... I've  
never had any trouble. And I didn't go broke buying raid controllers.  
GREAT software!

Thanks a bunch!
-Will Sheffler
