From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: two-disk-failure question
Date: Sat, 18 Oct 2003 09:46:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66704E241@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: maarten van den Berg <maarten@vbvb.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> "To get this to work, you'll need to have an up to date /etc/raidtab - if
it 
> doesn't EXACTLY match devices and ordering of the original disks this will 
> not work as expected, but will most likely completely obliterate whatever 
> data you used to have on your disks."

While the procedure you're refering to will still work, it's been made pretty
much obsolete by the new mdadm tool.

> Now I can't be completely absolutely sure I did not -at some point-
re-order 
> cables and such. So my obvious question is:  Is this step (mkraid --force 
> with one of the offline disks defined as failed-disk) destructive, or could
I 
> (theoretically) experiment endlessly with the order in which the disks are 
> defined in /etc/raidtab before I decide to mount it read-write and
raidhotadd 
> a fresh disk ?

Urr, hard question there: IF 
	- you've marked a disk as failed AND
	- there's no spare disks in your configuration THEN
yes, the mkraid -force is non - destructive. it'll only touch the raid
superblocks and nothing else. 

Be careful when checking the results of the operation though: even mounting a
filesystem readonly can result in write access to the device when using a
journaling filesystem (ext3). Prior to mounting, it'll try to play back the
jounal..

> Second question, If one is sufficiently adept at looking at raw disk 
> structures (notably the suberblocks), can a human find out which disk is 
> which, ie. in which order they DO belong ?

Yes :-)

OK, that wasn't really helpful. What you really want to do is grab a copy of
mdadm. It's got support for resolving just the problem you're experiencing:
it can override the event counter when assembling an array but still use the
rest of the raid superblock. In adition it can parse the information in the
superblock and show you exactly what's in each of your superblocks.

Bye, Martin
