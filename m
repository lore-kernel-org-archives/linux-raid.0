From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Linux software raid troubles
Date: Fri, 14 Apr 2017 20:23:22 +0100
Message-ID: <d8bf2e60-fd1f-1fe3-0744-0e9029ec5b69@youngman.org.uk>
References: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
 <8e9a25fc-5c81-103c-2ffa-4b46f2aa8630@thelounge.net>
 <CAAO=44bsG1yrmYbag1eruNA_tdXxqiJptnRyPB=4TW6r5771HQ@mail.gmail.com>
 <cbadbdeb-7e6b-7784-e49c-dd2801903bb6@thelounge.net>
 <CAAO=44Y9YspCqyfvDgx30mGO_VhYZpuj9D8U1O6063B8VL61vw@mail.gmail.com>
 <d1695ac6-5912-860a-0b70-e0d9a322002e@suddenlinkmail.com>
 <CAAO=44YCU+OF-xBytuMCHEtV7WbHE6EVyJ_9ncGmM9VNWcj9MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAO=44YCU+OF-xBytuMCHEtV7WbHE6EVyJ_9ncGmM9VNWcj9MA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linuxknight <linuxknight@gmail.com>, "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/04/17 16:01, linuxknight wrote:
> One last question, is it acceptable to let graphical installers setup
> the software raid for me or should I use one disk and create a raid
> mirror later once the OS is setup?

Can't give you any advice on how to do it, but I'd be inclined to create
one huge array using all your disks. For each physical disk, one 
partition for UEFI or grub, possibly a second partition for a mirrored 
root partition, then all the rest for a raid array with LVM on top.

I'm hoping to build a new system set up like that, but that's probably a 
few months down the line.

Oh - and using the installer to set it up is probably going to be a 
nightmare. My experience is gentoo, which expects me to set it up 
manually, or SuSE which was a pain setting up custom partitioning.

Cheers,
Wol
