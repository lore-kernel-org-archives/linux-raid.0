From: =?ISO-8859-1?Q?Miguel_Corber=E1n_Ruiz?= <migcorrui@gmail.com>
Subject: Problem halting raid 1
Date: Fri, 6 Sep 2013 12:42:23 +0200
Message-ID: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I am having a problem stopping an array. When I use the command "mdadm
--stop /dev/md0" the array disappears completely. It does not even
appear under /dev/m..

Then, when I try "mdadm --remove /dev/md0" bash tells me that /dev/md0
does not exist. So, after stopping the array with "mdadm --stop ..",
"cat /proc/mdstat" says that there is no array running. From what I
read the array should be visible but in a halted/stopped/deactivated
state. And then one can proceed to remove it.

What I want to do is to completely remove the array so I can mount the
individual partitions anywhere else without the need of mdadm (and
access the data created when the array was running).

Any help will be appreciated. Thank you in advance,
Miguel
