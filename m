From: "James R Bamford" <jim@jimtreats.com>
Subject: Software Raid 1 data corruptions..
Date: Sat, 15 Nov 2003 16:00:33 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOGEEEGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a system crash or two a few weeks ago and lost a lot of data.. i
strived to never be in as much danger again with my important files so i
built a linux box out of an old P3 450mhz machine.. i installed fedora core
1 linux (may try RH9 if this is the problem) and got the following hardware

Promise Ultra 100 IDE controller
2 x Samsung 8meg 160gig hdd

I thought the promise controller was a raid controller, not used it for a
while.. but its just plain ide.. tho on reading i discovered that most
hardware raid controllers that are affordable are software based anyways and
are basically just a controller with drivers to perform the raid
functionality in software..

Anyways i've wrestled through and got it all working (raid 1 mirroring on 2
drives).. even got it auto loading my raid array.. I followed the HOWTO
(http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html) and everything seemed
fine.. quite fun, although took a long time..

I just got it mounted and copied a file into it.. a 450meg image file... I
started running some md5 tests on the file (paranoid from other machines
recently having hdd corruptions) sadly i started to get this kind of result

[jim@backup test]$ md5sum image.nrg
 3b5da2f7ad0e174421306b62a636fa12  image.nrg

[jim@backup test]$ md5sum image.nrg
 4e815cd2c3ab565315ef47f53665f6ba  image.nrg

[jim@backup test]$ md5sum image.nrg
 a14990ebfd5c502a68c29e2f789a34dd  image.nrg

always different.. i may have had a repeat once or twice.. unbelievable
though.. this is the complete opposite of what i wanted.. security for my
backups... i copied the image to another hdd in my system, just a normal
mounted one.. ran the test and it got the correct md5sum.. well constantly..
all the time..

I've just recently unmounted /dev/md0 and stoped the raid device.. i wasn't
sure whether this was ok or not and couldn't find anyone to advice me but i
then mounted the component hdds seperately as read only and preceeded to
test each hdd seperately... they both passed the test repeatedly.. the same
md5sum each time (the same one as performed on the other hdd)

So it appears that the data is secure on the hdds ok.. its just reading them
back out is inconsistent...

Can anyone give me any advice on this.. should i buy a hardware raid card
(which is effectively software as its cheap), or a true hardware raid card
thats quite expensive... should i install a different OS,  are there any
patches i can try.. should i abandon linux for raid and try using windows...

Thanks for your time... HELP!!! really :)

Regards

Jim

