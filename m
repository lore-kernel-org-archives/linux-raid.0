From: Arka Sharma <arka.sw1988@gmail.com>
Subject: Re: Testing RAID 1 redundancy
Date: Thu, 1 Dec 2016 16:49:30 +0530
Message-ID: <CAPO=kN3gO3PQ-v2nrHs9eFhOoZLQ6S9+3BdCCPDbiM-Q_WT88g@mail.gmail.com>
References: <CAPO=kN2kcPA++DXw3H=S0+PrcVhJptBqAhX39uY7ZY-Q0VaJHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPO=kN2kcPA++DXw3H=S0+PrcVhJptBqAhX39uY7ZY-Q0VaJHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have done the following steps

1. Created a raid 1 with two PCIe SSD's say /dev/ssd1 /dev/ssd2 in
mdadm with 1.2
2. Created ext4
3. Mounted and created a file
4. Poweroff the system
5. Disconnect one PCIe SSD
6. Boot the system and mdadm --detail shows the status of array as FAILED
7. Stopped the array
8. Did mdadm --assemble --force /dev/md127 /dev/ssd1
9. Mounted the array and the file I created was intact
10. Issued mdadm --detail and status is reported as degraded

For the second case created raid 1 with ddf
Till step 7 everything was same as in with superblock 1.2
But when issued mdadm --assemble --force /dev/md126 /dev/ssd1 it shows
that /dev/ssd1 is busy skipping.
Checked in dmesg nothing is captured there

Is there any mistake in the procedure ?

Regards,
Arka

On Mon, Nov 28, 2016 at 2:50 PM, Arka Sharma <arka.sw1988@gmail.com> wrote:
> Hello,
>
> I want test a redundancy scenario with RAID 1. I have crated an array
> with mdadm and formatted ext4 and after mounting I have written a text
> file. Now I want to switch off one device, and with another remaining
> device I expect to view the text file. When I issue mdadm --detail it
> shows the State as active,FAILED,Not Started. But in dmesg I can't
> find any error message from md related to one of the physical disk
> missing. I was searching about this and I found some references of
> creating degraded RAID 1 with missing parameter in mdadm, but what I
> want to simulate is that let's say one of the disk has gone bad and
> not yet being detected under /dev and in this case we want to verify
> that if data is intact.
>
> Regards,
> Arka
