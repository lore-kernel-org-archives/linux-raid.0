From: =?UTF-8?B?Q2hyaXN0ZXIgQsOkY2tzdHLDtm0=?= <cbackstrom@chemist.com>
Subject: Firewire RAID bootparameters?
Date: Fri, 12 Dec 2003 13:45:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD9B878.3070002@chemist.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've recently bought a 160Gb firewire drive and RAID1:ed it to mirror my 
main harddrive. Unfortunately, the md subsystem seems to load before the 
firewire in the kernel bootsequence, which mean I have to do some weird 
stuff to make it work. Basically, I compiled the md system as modules 
(with the SCSI patch to make it work a bit better), and hid the modules 
in a different directory, so they wouldn't load. I later load them in 
manually rc.sysinit. This work, but is a little clumsy. Is there a way 
to use append any boot-parameters to lilo to make the RAID subsystem 
load the firewire system? Or is there another solution? Thanks,


/Chris

