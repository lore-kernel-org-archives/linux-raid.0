From: Mike Hardy <mhardy@h3c.com>
Subject: Question about how the raid code is  tested / idea for automated
 testing
Date: Thu, 06 Jan 2005 09:56:59 -0800
Message-ID: <41DD7BEB.5040502@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Something that struck me while wading through the whole ext3 journaling 
errors thread was a tongue-in-cheek suggestion to Peter that he picture 
the kernel as a state machine and start verifying it, to which Peter 
replied with a static analysis tool link.

I also recall a test script that someone cooked up to reproduce a raid6 
bug that involved loopback devices etc

Finally, I recall a couple of vague mentions that it was possible to 
exercise the code by putting faulty virtual block devices under it and 
simulating faults, and that there was someone, or a group of someone 
that does a fair amount of reliability testing (maybe it was RedHat?)

For no really good reason, that made me wonder how the code is tested, 
and if there were any automated test suites.

Assuming there aren't, I pictured a modular system that includes three 
parts.

1) a raid testing engine that takes some sort of raid command language 
and uses it to build a specified raid out of loop devices and faulty 
block devices and then exercise it using a specified set of tasks (load, 
failures, resysncs, etc) all the while posting results back to an URL 
where a CGI just logs them or something simple
2) a script generator that can crank out command files for the testing 
engine that cover all the various permutations.
3) an image-building system that produces a bootable ISO based on 
knoppix with a kernel from a kernel source tree you specify that will 
hit a configurable URL for a script to run

Then I'm picturing a cycle where new code can be built into an ISO, the 
script can generate all the test permutations, and set VMWare (or 
similar) going in a loop, harvesting results in a crash-proof way.

I'm not that skilled at C code anymore, but this kind of system is 
mostly just duct-tape (imho), and I can do that. It might be fun to play 
around with if there's value to it. I've been meaning to learn how to 
customize knoppix and automate vmware tasks anyway, and we already have 
the raid6 test as an example script.

-Mike
