From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Re: Re[2]: Concept problem with RAID1?
Date: Fri, 24 Mar 2006 16:39:46 +0000
Message-ID: <1143218386.28440.84.camel@kenny>
References: <392345161.20060324191520@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <392345161.20060324191520@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A much nicer way to get that sort of reliability would be for RAID6 to
periodically scan the blocks on the device and to use the extra
information to do ECC (and for RAID5 to at tell syslog).

John


