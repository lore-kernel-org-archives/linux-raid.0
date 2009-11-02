From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Setup for Performance
Date: Tue, 03 Nov 2009 12:43:13 +1300
Message-ID: <4AEF6E91.3090902@sauce.co.nz>
References: <4AEF579D.5040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEF579D.5040803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Dunn wrote:

> My original array was a raid6 of 9 WD caviar black drives, the chunk
> size was 64k. I use USAS-AOC-L8i controllers to address all of my drives
> and the TLER setting on the drives is enabled for 7 seconds.

> I have noticed slow rebuilding time when I first created the array and
> intermittent lockups while writing large data sets.

Does the USAS-AOC-L8i use a Marvell controller?

If so, someone was posting here recently that they have problems with it 
locking up under md RAID loads. Have a look over the past couple of 
months archives.

Regards,

Richard
