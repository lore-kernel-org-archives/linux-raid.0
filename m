From: Leon Woestenberg <leonw@mailcan.com>
Subject: Re: mapping of md device blocks to component blocks? (and vice versa)
Date: Mon, 20 Dec 2004 19:51:53 +0100
Message-ID: <41C71F49.4040700@mailcan.com>
References: <1102689902.3987.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1102689902.3987.60.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I would like to re-issue my earlier question:

Given the LBA (bad) block number of a disk drive, or the block number
of a partition, how can I tell which block on the /dev/mdX device
corresponds with it?

Or should I ask this elsewhere?

Regards,

Leon.


Leon Woestenberg wrote:

>Hello,
>
>given the LBA (bad) block of a disk drive, or the block number of
>a partition, how can I tell which block on the /dev/md? device
>corresponds with it?
>
>Also, vice versa, given a block number on the /dev/md device, how
>can I tell to which blocks it maps on the components?
>
>Regards,
>
>Leon.
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

