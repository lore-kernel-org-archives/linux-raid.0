From: Zdenek Behan <rain@matfyz.cz>
Subject: Re: Size limitation?
Date: Sat, 02 Jan 2010 00:30:59 +0100
Message-ID: <4B3E85B3.6080607@matfyz.cz>
References: <201001011457.24334.mmclagan@invlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001011457.24334.mmclagan@invlogic.com>
Sender: linux-raid-owner@vger.kernel.org
To: mmclagan+reply@invlogic.com
Cc: Michael McLagan <mmclagan@invlogic.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/01/2010 08:57 PM, Michael McLagan wrote:
>    I'm trying to set up a large array but isn't working.  I tried 
> Googling size limits, etc and came up empty.
>
> The problem is that with 10 drives (300GB SCSI), the array is coming up 
> with 500GB of space?!?  I did an experiment and when the array size 
> exceeds 2TB, it fails/wraps?
>   
Just curious, did you compile your kernel with LBD (Large Block Device)
support?


Zdenek
