From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: Preventing a RAID device from starting until all disks are ready
Date: Mon, 18 Oct 2010 14:00:03 -0400
Message-ID: <4CBC8B23.1050408@cdf.toronto.edu>
References: <505206.15544.qm@web65407.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505206.15544.qm@web65407.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

My apologies for the late reply, but I've been over-busy at work.

> I've never heard of that - sounds fantastic.  Does it have any performance penalties during heavy writes?

There has to be some performance penalty, since for every write on the 
array, there is an additional write in the write-intent bitmap. However, 
it can be imposed on a device other than your RAID array by keeping the 
write-intent bitmap as a file on a separate file-system. In the mdadm 
manpage, it is specified that the write-intent bitmap can either be 
"internal" - in the MD superblock, or external - in a file. We have kept 
it internal for now, since we experience significantly less writes than 
reads. However, we are keeping in mind the option to move it off to 
another file-system if this changes, or we see our write performance 
impacting our users.

> Are you doing the mdadm startup in rc.local, or in the initrd, or...?

We have disabled all of the system startup-scripts, and we have cooked 
our own startup script which does each stage of the startup. In our 
case, we need the following order of operations:

1) Start networking, and bring up a set of bonded interfaces.
2) Login over iscsi to 30 iscsi target drives.
3) Start mdadm
etc.

Cheers,
Iordan
