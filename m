From: =?ISO-8859-1?Q?Jarmo_J=E4rvenp=E4=E4?=
	<Jarmo.Jarvenpaa@softers.net>
Subject: Re: RAID 5 questions
Date: Mon, 02 Aug 2004 09:01:14 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410DD8AA.6060609@softers.net>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040801033109.GA23032@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Ninti Systems <office@ninti.com.au>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Umm, I maybe writing on complitely different setup (can't check the 
original post), but our server with software raid 5 (3 disks) is booting 
with lilo just fine.


BR,
Jarmo


Jim Paris wrote:

>>Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?
> 
> 
> LILO does not support booting off of RAID 5, and I don't think GRUB
> does either.  I usually make a small RAID-1 partition to boot from
> (mirrored across all four drives), since LILO does handle that just
> fine.
> 
> 
>>geometry = 2498/255/63, sectors = 40132503, start = 0
> 
> ..
> 
>>geometry = 39813/16/63, sectors = 40132503, start = 0
>>Is this an issue with software RAID? 
> 
> 
> No.
> 
> -jim
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
