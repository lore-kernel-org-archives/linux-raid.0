From: Patrik Jonsson <patrik@ucolick.org>
Subject: Strange behaviour on "toy array"
Date: Sun, 15 May 2005 11:22:52 -0700
Message-ID: <4287937C.3090307@ucolick.org>
References: <62b0912f0504220345349335f9@mail.gmail.com>	 <62b0912f050512015585a6ba5@mail.gmail.com>	 <17028.5921.815691.401690@cse.unsw.edu.au> <62b0912f05051511107a0c4e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f05051511107a0c4e0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi all,

I'm gearing up to setting up a 2tb raid for our research group, and just 
to see how this stuff works I made a loopback array on one of my 
machines. I created 5 loopback devices of 1mb each, created a raid5 
array and formatted. so far so good. I could copy files on and off, fail 
a disk with mdadm -f  and then return it and everything seemed to work 
as i expected. Then I decided to see what happens if things go bad, so i 
fail one disk. fine, array reports "clean, degraded" but I can still 
access files. Then I fail another, now expecting not to be able to read 
anything. But, array reports "clean, degraded" and I can still access 
the files. I then proceeded to fail ALL disks and the array was still 
"clean, degraded" and I could read the files on it just as well as 
before??? Can anyone explain to me what's going on here? Was I seeing 
some cached version (given that the array was so small)?

This is on a machine running fedora core 3 ppc.

thanks,

/Patrik

