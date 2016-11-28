From: Arka Sharma <arka.sw1988@gmail.com>
Subject: Testing RAID 1 redundancy
Date: Mon, 28 Nov 2016 14:50:18 +0530
Message-ID: <CAPO=kN2kcPA++DXw3H=S0+PrcVhJptBqAhX39uY7ZY-Q0VaJHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I want test a redundancy scenario with RAID 1. I have crated an array
with mdadm and formatted ext4 and after mounting I have written a text
file. Now I want to switch off one device, and with another remaining
device I expect to view the text file. When I issue mdadm --detail it
shows the State as active,FAILED,Not Started. But in dmesg I can't
find any error message from md related to one of the physical disk
missing. I was searching about this and I found some references of
creating degraded RAID 1 with missing parameter in mdadm, but what I
want to simulate is that let's say one of the disk has gone bad and
not yet being detected under /dev and in this case we want to verify
that if data is intact.

Regards,
Arka
