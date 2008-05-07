From: rosenfield.albert@gmail.com
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Wed, 7 May 2008 13:22:18 +0200
Message-ID: <c4985c940805070422lfde5f6bhd510c12d2f2d0f2f@mail.gmail.com>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
	 <48013976.6020705@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48013976.6020705@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:
>  There is a md RAID feature called "repair", which can be regularly
> scheduled via a cron job and will do a full check and repair of the entire
> array.
>
>  This can be initiated with the command:
>
>  echo repair > /sys/block/mdX/md/sync_action
>
>  where mdX is your array.
>
>  More information on md RAID options can be found in the file md.txt, in the
> Documentation directory of the kernel source.

Beautiful, just what I was looking for.

Thanks!

(How about forcibly assembling an array where one too many disks has
been kicked?  Is that still, uhm, contorted to say the least? Or is
there a proper feature for that too?)
