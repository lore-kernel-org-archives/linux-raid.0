From: AndyLiebman@aol.com
Subject: Drives labeled as faulty by mdadm but are present
Date: Tue, 4 Nov 2003 13:11:33 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <147.1bd05af5.2cd945d5@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

I'm puzzled. I have 6 Firewire drives -- sda1-sdf1 -- in a RAID 10 array. 

Each drive has only one primary partition. I have three pairs of RAID 1 
arrays. On top of that I have a RAID 0 array using all six drives. 

I just had to reinstall Mandrake 9.2. After successful installation, when I 
tried to activate the arrays with mdadm (I saved the uuid information for each 
array, of course) , two of the drives came up as faulty. 

When I ran  mdadm -E /dev/sdX1   on each drive, I saw that there were indeed 
two drives with each of the three uuid's. In other words, all of the required 
drives with the correct uuids were found. The two drives marked "faulty" say 
"dirty, no errors" -- and they have uuids that match two of the other drives 
that ARE active. 

And when I run  mdadm -Av uuid={string of numbers/letters} /dev/md0  or   
/dev/md2, mdadm tells me that 2 drives have been found but it's only starting the 
array with one drive. 

My questions are:  

1)  Does anybody know why this has happened? It is likely that the device ids 
changed for my drives with this Mandrake reinstallation because I moved 
around one of my PCI firewire cards to a different slot. Is it possible that, as a 
result Linux Raid getting confused about which of the two drives in each array 
is supposed to be the "main drive" and which is the "copy"? Does that matter? 

2)  At this point, Is there a way to reactivate the faulty drives without 
having to resync the arrays? 

3)  If the answer to number 2 is "no", what do I have to do to get the faulty 
drives back into the arrays? 

4)  Do you think this could have anything to do with using the XFS filesystem 
on those arrays? 



Finally, I have one more question. 

When I reinstalled Mandrake 9.2, the installation program detected that the 
arrays were there. (Last time I installed Mandrake, I built the arrays AFTER 
installation) 

So now each time I boot up Linux, I see that the raid autostart is being 
detected on my drives. I never used to see this before this re-install  -- even 
after creating the arrays. I want to start my arrays manually after each boot 
up. I don't want them to start automatically. I don't even want Linux to try to 
start them automatically. 

Have I gotten myself into an unstable situation? If so, how do I correct it? 


Thanks in advance for your help. 
