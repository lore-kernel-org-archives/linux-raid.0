From: Marc Bevand <bevand_m@epita.fr>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 17:37:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ca7b0u$ngr$1@sea.gmane.org>
References: <200406082012.58968.linux_mail@rozpooh.com> <yw1xise1tdif.fsf@kth.se> <1086777225.40c6e789ade9f@www.tastycake.net> <40C6ECEE.8090706@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40C6ECEE.8090706@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> I have wondered whether I'd have been better off with 2x Promise TX2s?
> I don't know where the bottleneck is with 4xSATA disks on a single 
> Promise/PCI slot

I have 4 x Seagate 160GB SATA connected on a Promise SATA150 TX4. The
bottleneck is always the PCI bus:

  o 66 MHz PCI bus (266 MB/s): I reach 209 MB/s (79% of theoretical bandwidth)
  o 33 MHz PCI bus (133 MB/s): I reach 100 MB/s (75% of theoretical bandwidth)

Note: each disk is able to generate a datas rate of about 57 MB/s.

-- 
Marc Bevand                          http://www.epita.fr/~bevand_m
Computer Science School EPITA - System, Network and Security Dept.

