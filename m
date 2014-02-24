From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 09:30:03 +0800
Message-ID: <530AA09B.3090708@fnarfbargle.com>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/14 02:09, Mikael Abrahamsson wrote:
>

> If this doesn't seem like a sensible approach, what would be a sensible
> approach to avoid having pending sectors keep being "pending" even after
> "check" and "repair"?
>

The only reason I've ever seen this personally was when the pending 
sectors were on non-data parts of the drive, like some of the space 
around the superblock. Have you verified that these issues are really on 
sectors in the data area? SMART should tell you the LBA of the first 
error in a read test.

Brad
