From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Tue, 25 Jan 2005 00:35:51 +0000
Message-ID: <ct447m$l90$1@sea.gmane.org>
References: <20050124145910.GC29766@kaneda> <16885.31484.125772.316987@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16885.31484.125772.316987@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> If you are using a recent 2.6 kernel and mdadm 1.8.0, you can grow the
> array with
>    mdadm --grow /dev/mdX --size=max

Neil,

Is this just for RAID1? OR will it work for RAID5 too?

R.
-- 
http://robinbowes.com

