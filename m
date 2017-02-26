From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID10 reshape and change lout possible?
Date: Sun, 26 Feb 2017 21:28:34 +0100
Message-ID: <3ef7f0b2-1f3e-40e2-ab23-3ff9436f9ced@thelounge.net>
References: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
 <20170226185147.GD21587@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170226185147.GD21587@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 26.02.2017 um 19:51 schrieb Andy Smith:
> On Sun, Feb 26, 2017 at 03:37:24PM +0100, Reindl Harald wrote:
>> is it somehow possible to change a existing md RAID10 array from "2
>> near-copies" to "2 far-copies" and what would be the mdadm syntax?
>
> https://manpages.debian.org/jessie/mdadm/mdadm.8.en.html suggests
> that --grow --layout can be changed on RAID-10. I have never tried
> it myself. Experiment with loop devices. It looks like the syntax
> would be:
>
> # mdadm --grow /dev/mdX --layout=f2

thanks for your answer

the syntax seems to be correct given the error message says clear 
"Cannot reshape RAID10 to far-mode" which sadly answers the question - 
at least for now, maybe that will change in the future

[root@testserver:~]$ mdadm --grow /dev/md0 --layout=f2
mdadm: Cannot reshape RAID10 to far-mode

[root@testserver:~]$ rpm -q mdadm
mdadm-3.4-3.fc24.x86_64

[root@testserver:~]$ uname -a
Linux testserver.rhsoft.net 4.9.12-100.fc24.x86_64 #1 SMP Thu Feb 23 
21:29:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
