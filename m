From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-5 Parity calculation
Date: Thu, 14 Oct 2004 17:39:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410142139.i9ELdhN25029@www.watkins-home.com>
References: <1097778662.2926.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097778662.2926.9.camel@localhost.localdomain>
To: 'Yinan Liu' <yinan@ele.uri.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If D1, D2, D3 or D4 change, then P must also change.

If all D1, D2, D3 and D4 change, then md can compute P without any reads.
Then write D1, D2, D3, D4 and P.

If less than all D1, D2, D3 and D4 change, then md has 2 options, md does
whichever requires less disk I/O.

1) md must read the unchanging data and read P, compute a new P and write
the changes.

2) Read the old D1, D2, D3 and/or D4 (whichever is changing) and read P.
Then factor out the old data from P, then factor in the new data, write all
changes.

Example 1:
	D1, D2 and D3 are changing.
	md will read D4, using D1, D2, D3 and D4 (from memory) compute new
P, write D1, D2, D3 and P.

Example 2:
	D1 is changing.
	md will read old D1 and P.  Factor out old D1 from P.  Factor new D1
into new P, write D1 and P.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Yinan Liu
Sent: Thursday, October 14, 2004 2:31 PM
To: linux-raid@vger.kernel.org
Subject: RAID-5 Parity calculation

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



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

