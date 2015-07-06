From: Nate Dailey <nate.dailey@stratus.com>
Subject: raid1 - mismatches after resuming interrupted recovery
Date: Mon, 6 Jul 2015 12:19:54 -0400
Message-ID: <559AAAAA.2030904@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've found that if I interrupt a recovery by removing the target device, do IO 
before the recovery checkpoint, then re-add the device and let the recovery 
complete, the mismatch_cnt is non-zero after doing a check.

Here's exactly what I'm doing:

- create a 5 GB raid1 with internal bitmap

- do a check, verify zero mismatch_cnt

- remove one member device

- dd 256MB with 2GB seek

- lower sync_speed_min/max to 500

- re-add removed device

- wait 15 sec

- remove the same member device again

- dd 1MB with 1 GB seek

- restore sync_speed_min/max to system defaults

- re-add removed device

- when recovery competes, do another check

At this point the mismatch_cnt is non-zero.


I originally hit this on RHEL 7.1, but tested 4.1.1 from kernel.org and it 
happens there too.

I'm out of my league in terms of trying to fix this, but would be happy to test 
a fix. I wonder if it's really necessary to resume a bitmap recovery from the 
checkpoint? Wouldn't the bitmap always reflect what needs to be copied?

Nate

