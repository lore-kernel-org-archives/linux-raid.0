From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: Re: RAID10 vs. LVM on RAID1
Date: Mon, 22 Aug 2005 17:24:32 -0500
Message-ID: <430A50A0.4070608@dynaconnections.com>
References: <20050822213100.GA6165@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050822213100.GA6165@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gregory Seidman wrote:

>Is there any advantage to RAID10 over creating an LVM volume group across
>the same number of RAID1 pairs? LVM does striping, after all. Am I
>overlooking something?
>  
>
This may have changed, but the last time I checked (~2.6.3) LVM was 
significantly slower in this regard.  In general I've found LVM to be a 
performance bottleneck.

-ryan
