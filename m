From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RAID-6 development snapshot
Date: Tue, 26 Nov 2002 14:46:04 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DE3F9AC.4040107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Because some people asked, I dropped a development snapshot of the 
RAID-6 code at:

ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/raid6-20021126-dontuse.tar.gz

THIS IS NOT A WORKING RAID-6 IMPLEMENTATION.  It's my current 
development snapshot, and attempting to use it *will* result in crashes 
and kernel panics.

It does, however, contain a RAID-6 algorithm test and benchmark program 
that should work.

	-hpa

