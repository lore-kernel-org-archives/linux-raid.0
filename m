From: "michael michael" <danshoe@gmail.com>
Subject: Questions about RAID1/RAID5 read error handling
Date: Tue, 5 Dec 2006 20:42:57 +0800
Message-ID: <c03b90ed0612050442i2d41d274i3edf0c84c269b523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have several questions about RAID1/RAID5 read error handling.
Any help is appreciated, thanks.

After I created a md, what will md driver do if a read error is
encountered in the following conditions:
1. during md is resyncing?
2. after md is resync-ed?
3. when md is degraded?
4. during md is recovering?

My current kernel is 2.6.15.7, but I saw patches for the read errors
handling in 2.6.16/18.
What are the changes of read error handling after 2.6.16?

Any help is appreciated, thanks.

--
Best Regards,
Michael Yao
