From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 05 Aug 2003 00:32:48 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2E8AB0.20102@shaolinmicro.com>
References: <3F2D1FAC.9030905@shaolinmicro.com> <1060000902.30302.9.camel@cinshrlnxws01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Rechenberg wrote:

>I've seen this behavior occur on my RAID-1 arrays after using mdadm to
>hotadd drives.  If I wait a little while the recovery thread does wake
>up and starts the resync, but it doesn't occur immediately after the
>hotadd.
>
>I'm not sure if this type of behavior is expected, but I have seen it.
>
>Running RH 2.4.18-27bigmem with /proc/mdstat seq_file, and megaraid2
>patches
>  
>
Yes thanks. My RAID hotadd since last night and still the same. Resync 
thread never starts.

regards,
David Chow


