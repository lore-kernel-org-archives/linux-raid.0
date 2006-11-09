From: "=?ISO-8859-1?Q?R=E9mi_VM?=" <eremid@gmail.com>
Subject: Randomly kernel panic with MPT SPI driver 3.04.01
Date: Thu, 9 Nov 2006 10:18:36 +0100
Message-ID: <b6f57fe10611090118p5946b397x5d53d665309f4fc3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've go a randomly kernel panic with a 2.6.18.1 kernel (MPT SPI driver
3.04.01) when i start my server with  a LSI 53C1030 :
---
Fusion MPT base driver 3.04.01
 Copyright (c) 1999-2005 LSI Logic Corporation
 Fusion MPT SPI Host driver 3.04.01
 mptbase: Initiating ioc0 bringup
 mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
 mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
 mptbase: ioc0: ERROR - Diagnostic reset FAILED! (102h)
 mptbase: ioc0 NOT READY WARNING!
 mptbase: WARNING - ioc0 did not initialize properly! (-1)
 mptspi: probe of 0000:02:05.0 failed with error -1
 mptbase: Initiating ioc1 bringup
--

My server : Intel SR1400SYS
http://developer.intel.com/design/servers/chassis/sr1400/index.htm

Thanks for your help !
