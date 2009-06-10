From: "Ing. Jair" <jairzhino@gmail.com>
Subject: mdadm message (auto-read-only) on "/dev/md1" = swap file system
Date: Wed, 10 Jun 2009 12:10:43 -0500
Message-ID: <2b91784d0906101010l409c38d2m8d0e7401c454307f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux -raid community masters,


I have a quick question regarding something i noticed on my first time
mdadm linux raid configuration server:


Current System:

Debian Lenny 5.0
Two 250GB hard drives identical brand, size, model, speed, etc... they
are the same.
3GB memory ram
1 AMD athlon 2500 CPU

Here I am pasting an example of another machine I configure with the
same result notice the "(auto-read-only)" message on the swap file
system:


md2 : active raid1 hde3[0] hdg3[1]
      153557184 blocks [2/2] [UU]

md1 : active (auto-read-only) raid1 hde2[0] hdg2[1]
      2634560 blocks [2/2] [UU]



md0 : active raid1 hde1[0] hdg1[1]
      96320 blocks [2/2] [UU]

unused devices: <none>


My question for this is:

1. Is this the way suppose to work on the device md1 = swap filesystem raid?

2. If this is normal where can I find documentation about the
different "messages" displayed on the command "cat /proc/mdstat"?

3. If this is a bug, is there a work around and what will happen if
this continue to appear?

4. I ran the command mdadm -w /dev/md1 and the message disappear, but
after rebooting the system came back up.

I appreciate any information or document, links, ideas you can provide to me.

I look forward to your response.

Sincerely,

--
Jairzhino Bolivar (Jair)
GNU/Linux & Unix Administrator
Mobile: (312)404-6530
Fax: (214)602-4405
