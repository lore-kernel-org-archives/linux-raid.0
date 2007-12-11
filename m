From: "Kumar Surender" <R66464@freescale.com>
Subject: FW: Query regarding Async layer functionality for Memory Copy
Date: Tue, 11 Dec 2007 15:08:42 +0530
Message-ID: <0632814B812B324AAA6BA883E0F51916EDEA2D@zin33exm20.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I am facing a problem that Async layer is not able to find any
registered DMA channel for Async memory copy operation. 

DMA driver is working properly i.e. Standalone DMA functionality is
working fine and it registers successfully with the Async layer. But in
return, Async layer is not able to find any DMA channel when it requires
it for async memory copy operations and thus Async layer goes for
synchronous memory copy operations.

Linux version :- Linux-2.6.23-rc4
Board         :- 837x

Has anybody tested functionality of Async layer for memory copy/XOR
operations??

Thanks in Advance,

Thanks & Regards
Surender




