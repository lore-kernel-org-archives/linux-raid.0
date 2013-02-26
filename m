From: EJ Vincent <ej@ejane.org>
Subject: Functioning of --backup-file prior to array growth.
Date: Mon, 25 Feb 2013 23:09:18 -0500
Message-ID: <512C356E.6070803@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I didn't want to hijack Kevin's "Damage when growing RAID 5 array" 
thread, but this got me thinking about my past experiences.

I'm preparing to add a disk to an existing RAID6.

In the past (more than one occasion) I've specified: 
"--backup-file=/disk/not/part/of/array/md.bak" and then, after starting 
the growth, I've gone to this path, and seen nothing created.

Is this a file that is created *only* in the event of an error / 
failure? Should some data be written to this .bak file immediately? If 
not, what could be preventing this file from being created?

Thanks for your input.

-EJ
