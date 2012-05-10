From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 13:29:42 +1200
Message-ID: <4FAB1A06.10502@clear.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Daniel Pocock <daniel@pocock.com.au> wrote:

 > ignoring the better MTBF and seek times of these drives, do any of the
 > other features passively contribute to a better RAID experience when
 > using md?

An important one for large arrays is the ability to handle the level of 
chassis vibration/resonance from adjacent drives, which has a marked 
effect on seek times (this feature is called RAFF in Western Digital 
RAID Edition drives), and is not available in desktop drives.

Regards,

Richard
