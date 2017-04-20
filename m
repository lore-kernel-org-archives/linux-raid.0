From: Matthias Dahl <ml_linux-raid@binary-island.eu>
Subject: Re: IMSM RAID10: Rebuild/Resync difference on Linux vs Windows
Date: Thu, 20 Apr 2017 09:44:21 +0200
Message-ID: <01c2b1cd-1893-d299-5907-0b5be5f13776@binary-island.eu>
References: <055fbb58-fb5f-5d69-0974-aaa234c99028@binary-island.eu>
 <4f749c02-3478-cafc-2ae4-40af25459f65@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4f749c02-3478-cafc-2ae4-40af25459f65@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Artur...

So, the same thing happened again yesterday: The RAID10 was out of sync
due to an unclean shutdown and while Linux was at 70.8% of the resync, I
restarted to Win 10 with RST 15.2.0.1020 and it recognized the RAID as
clean without any visible/noticeable verification at all.

I did a manual verification run in Win this time, just for the sake of
it, and it came up fine.

Nevertheless, this really has me worried. Did you get / see my last mail
with the information you requested?

By the way, kernel version was 4.10.8 with mdadm/mdmon 4.0.

Thanks,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
 Hire me for contract work: Open Source, Proprietary, Web/Mobile/Desktop
