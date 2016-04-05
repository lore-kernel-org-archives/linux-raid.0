From: Ron Leach <ronleach@tesco.net>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Tue, 05 Apr 2016 12:04:44 +0100
Message-ID: <57039BCC.6040103@tesco.net>
References: <57038211.6040101@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57038211.6040101@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2016 10:14, Ron Leach wrote:
>
> Presumably, I need to set up the partition table again. These are
> identical discs from the same manufacturer. Elsewhere, people have
> suggested using:
>
> sfdisk -d /dev/sdc | sfdisk /dev/sdb
>

(Apologies for replying to my own post.)

Everybody will have noticed how ill-prepared I am;

man sfdisk

explains, right at the start, that sfdisk will NOT work with gpt 
partitions.

I'll look at parted and gdisk.

Ron
