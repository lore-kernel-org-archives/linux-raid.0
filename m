From: Tyler <pml@dtbb.net>
Subject: Re: Software RAID on Windows using Embedded Linux?
Date: Sun, 24 Jul 2005 19:57:26 -0700
Message-ID: <42E45516.4010803@dtbb.net>
References: <6d5bedd8050724070995073e1@mail.gmail.com>	 <62b0912f050724075638c18d91@mail.gmail.com>	 <6d5bedd8050724113142284b32@mail.gmail.com> <6d5bedd805072412183b94bb4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd805072412183b94bb4f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm is just the tool to manipulate (start, stop, create, view) a raid 
device and its components.. the MD (md) driver is part of the linux 
kernel (or a kernel module), and is the one doing the actual raid work 
(XOR, striping, etc.).

Regards,
Tyler.

Ewan Grantham wrote:

>One other idea I've had (and y'all can tell me how much I'm showing my
>lack of knowledge in this area) is to try recompiling the mdadm and
>other tools using cygwin. But I assume that this is an idea that's
>been floated before and didn't work since I haven't seen any signs of
>this having been done before, and it seems like a pretty obvious one
>if it were easy to do.
>
>Thanks again,
>Ewan
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
