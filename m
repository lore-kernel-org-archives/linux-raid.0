From: AndyLiebman@aol.com
Subject: Re: mdadm can't start RAID0 volume after power failure
Date: Fri, 17 Dec 2004 13:06:56 EST
Message-ID: <128.5252547e.2ef47a40@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philippe.gramoulle@mmania.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Phillipe

>Still, this is the first time that such a thing happens to me. What could be 
the reason that >UUID would be changed ?

If I were a betting person, I would say that the mdadm.conf file was old, and 
that you had created a new array since the time you made that conf file. And 
you just didn't update the conf file. 

As I'm sure you know, you don't need to use a conf file anyway to use mdadm. 
That's what makes it so beautiful! All kinds of things -- like device ids -- 
can change on your system and mdadm just figures it out (provided you give it a 
minimal amount of info, like the correct uuid!). 

Glad to help :)
Andy Liebman
