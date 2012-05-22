From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid 10f2 vs 1 on 2 drives
Date: Wed, 23 May 2012 00:36:12 +0200
Message-ID: <4FBC14DC.8070007@hesbynett.no>
References: <20120522193340.GM27769@electro-mechanical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120522193340.GM27769@electro-mechanical.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/12 21:33, William Thompson wrote:
> I understand that raid 10 f2 is slower on writes due to the location of the
> 2nd copy.  My question is, if lots of writes are performed, could this
> layout wearout the drives quicker than raid 1?

No, wear is not going to be significantly different.

You didn't say whether you are talking about hard disks (where location 
makes a difference, but "wear" on the drive motor is insignificant to 
the disk's expected lifetime), or flash disks (where people often worry 
about "wear", though location is irrelevant and wear is also irrelevant 
for most uses of all but the most cheapo disks).

