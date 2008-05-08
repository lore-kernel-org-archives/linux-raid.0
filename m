From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Thu, 08 May 2008 13:13:37 +1200
Message-ID: <482253C1.5060803@sauce.co.nz>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>	 <48013976.6020705@sauce.co.nz> <c4985c940805070422lfde5f6bhd510c12d2f2d0f2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c4985c940805070422lfde5f6bhd510c12d2f2d0f2f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rosenfield.albert@gmail.com wrote:

> 
> (How about forcibly assembling an array where one too many disks has
> been kicked?  Is that still, uhm, contorted to say the least? Or is
> there a proper feature for that too?)

Depends what you mean by contorted. Have a look at the "For assemble" 
section of the mdadm man page.

mdadm -A --force /dev/mdX /dev/sda1 /dev/sdb1 /dev/sdc1

does not seem contorted to me.

Regards,

Richard
