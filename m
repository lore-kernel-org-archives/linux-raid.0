From: Yinan Liu <yinan@ele.uri.edu>
Subject: RAID-5 Parity calculation
Date: Thu, 14 Oct 2004 14:31:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097778662.2926.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I am a new guy for a Linux programming. I got a question for a
software RAID-5 parity calculation. 

If we suppose for data block D1, D2, D3, D4 with a parity block P, When
some data block is changed, P will be changed. I am not so clear how
does Linux md handle the parity re calculating, when data changed . 

Suppose there will be three cases, 

1. sequential write, is that get new P' directly with new data D1', D2',
D3' and D4' or need read D1-4 out from disk doing the normal operation. 

2. if we changed there blocks, D1',D2' and D3', does md read D1, D2, D3
out to rebuild P or just read D4 out from disk and rebuild P with D1',
D2', D3' and D4. 

3. is the simple case, just change one block. 

Thanks a lot, if some can help me get understand it. 



