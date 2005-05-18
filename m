From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 22:30:55 -0500
Message-ID: <428AB6EF.3020401@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <428A814D.3000803@home.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A814D.3000803@home.se>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik_holst@home.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Henrik Holst wrote:
> You might also want to try and force UltraDMA mode5 (or the highest 
> UltraDMA mode supported by your hardware) with "hdparm -X69 /dev/hda" 
> combined with the "Multiple sector mode" (set with "hdparm -m 16 
> /dev/hda") that was suggested earlier.
> 

No luck, thanks for the attempt though

Jay
