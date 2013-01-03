From: "Alex Leach" <beamesleach@gmail.com>
Subject: Re: RAID5 member disks shrunk
Date: Thu, 03 Jan 2013 18:05:22 -0000
Message-ID: <op.wqcki8gm8s54ea@metabuntu>
References: <op.wqcditj08s54ea@metabuntu> <20130103214236.3fe60580@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130103214236.3fe60580@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Replying again, on list. Sorry Roman)

On Thu, 03 Jan 2013 15:42:36 -0000, Roman Mamedov <rm@romanrm.ru> wrote:

> Try checking if your controller/BIOS have shrunk the disk by  
> establishing an
> HPA on it, the easiest way to check if you have any is perhaps with
>
>   dmesg | grep HPA
>
> If that is indeed the case, you can control it with "hdparm -N" (see its  
> man page).
>

Thanks for the reply.
The dmesg command produces no output. Anywhere else I should look?

Cheers,
Alex

-- 
Using Opera's mail client: http://www.opera.com/mail/
